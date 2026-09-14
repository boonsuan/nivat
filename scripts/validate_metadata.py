#!/usr/bin/env python3
"""Validate local v0.4 metadata and selected Palomar mechanical requirements.

The official schema is vendored unchanged with its license and checked digest.
Policy extras follow CONTRIBUTING.md at e9c8c238f5695b10f75db7175648a1d0195352c1.
This project-specific check supports the chosen MIT license. It does not replace
the registry's verifier, editorial review, identity/authorization checks, or
Comparator. It performs no submission and sends no project metadata anywhere.
Only pinned public taxonomy data is downloaded, unless --offline is supplied.
"""

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from urllib.request import urlopen

import yaml
from jsonschema import Draft7Validator

ROOT = Path(__file__).resolve().parents[1]
SCHEMA = ROOT / "docs/schema/formalization.v0.4.schema.json"
SCHEMA_SHA256 = "25ff6b25ca4511635aff4443cf20480c15e59dddf19591c730950b442ea54fce"
TAXONOMY_PIN = "ef2fa1eadcb246c2346ddba39b52eaa53d4bb763"
TAXONOMIES = {
    "arxiv": ("arxiv-categories.json", "3b339cf140a914c50bab39b1c44df2437ce3984bd09bb2150fcb0edd60eda776"),
    "msc2020": ("msc2020-codes.json", "b4de69f1f562da01e0f4580cecc0ab36098f5297bb7cdd669c8ec3b0d3606060"),
}
SOURCE_RELATIONSHIPS = {"formalizes", "adapts", "independently-proves", "background", "other"}
SOURCE_TYPES = {"paper", "book", "web discussion", "folklore", "original-proof", "other"}
TEMPLATE_MARKER = re.compile(
    r"^TEMPLATE|\b(?:TODO|TBD|FIXME|CHANGEME|REPLACE_ME)\b|example\.(?:com|org|net)\b|<your\b",
    re.IGNORECASE,
)
LICENSE_NAME = re.compile(r"(?:LICENSE|LICENCE|COPYING|UNLICENSE|OFL)(?:\.(?:md|markdown|txt))?", re.I)
MIT_TERMS = """Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."""


class MetadataError(ValueError):
    """An actionable local metadata validation failure."""


class StrictLoader(yaml.SafeLoader):
    """Safe YAML with duplicate and merge keys rejected before construction."""

    def construct_mapping(self, node, deep=False):
        keys = set()
        for key_node, _ in node.value:
            if key_node.tag == "tag:yaml.org,2002:merge":
                raise MetadataError(f"YAML merge key at line {key_node.start_mark.line + 1}")
            key = self.construct_object(key_node, deep=deep)
            if not isinstance(key, str):
                raise MetadataError("metadata mapping keys must be strings")
            if key in keys:
                raise MetadataError(f"duplicate YAML key {key!r} at line {key_node.start_mark.line + 1}")
            keys.add(key)
        return super().construct_mapping(node, deep=deep)


def require(condition, message):
    if not condition:
        raise MetadataError(message)


def regular_text(path, max_bytes):
    require(path.is_file() and not path.is_symlink(), f"{path}: expected a regular, non-symlink file")
    require(0 < path.stat().st_size <= max_bytes, f"{path}: empty file or exceeds {max_bytes} bytes")
    return path.read_text(encoding="utf-8")


def check_filled(value, path="$", ancestors=None):
    """Reject unfinished template text, empty text, and recursive YAML aliases."""
    ancestors = set() if ancestors is None else ancestors
    if isinstance(value, str):
        require(value.strip(), f"{path}: omit optional empty text fields instead of leaving blanks")
        require(not TEMPLATE_MARKER.search(value.lstrip()), f"{path}: unresolved template marker")
    elif isinstance(value, (dict, list)):
        require(id(value) not in ancestors, f"{path}: recursive YAML alias")
        ancestors.add(id(value))
        items = value.items() if isinstance(value, dict) else enumerate(value)
        for key, item in items:
            check_filled(item, f"{path}.{key}", ancestors)
        ancestors.remove(id(value))


def taxonomy_codes(kind, offline):
    filename, digest = TAXONOMIES[kind]
    cache = ROOT / ".tools/metadata/taxonomies" / filename
    if not cache.exists():
        require(not offline, f"missing taxonomy cache {cache}; run once without --offline")
        url = f"https://raw.githubusercontent.com/PalomarRegistry/PalomarSubmission/{TAXONOMY_PIN}/taxonomies/{filename}"
        with urlopen(url, timeout=30) as response:
            data = response.read()
        require(hashlib.sha256(data).hexdigest() == digest, f"downloaded {filename}: digest mismatch")
        cache.parent.mkdir(parents=True, exist_ok=True)
        cache.write_bytes(data)
    data = cache.read_bytes()
    require(hashlib.sha256(data).hexdigest() == digest, f"cached {filename}: digest mismatch")
    return json.loads(data)


def check_classification(data, offline):
    classification = data.get("classification", {})
    for kind, minimum in (("arxiv", 1), ("msc2020", 0)):
        values = classification.get(kind, [])
        require(minimum <= len(values) <= 8, f"classification.{kind}: require {minimum}–8 codes")
        require(len(set(values)) == len(values), f"classification.{kind}: codes must be distinct")
        if values:
            unknown = set(values) - taxonomy_codes(kind, offline).keys()
            require(not unknown, f"classification.{kind}: unknown codes {sorted(unknown)}")


def check_license(data):
    require(data["project"]["license"] == "MIT", "project.license must match this project's chosen SPDX identifier MIT")
    licenses = [p for p in ROOT.iterdir() if LICENSE_NAME.fullmatch(p.name)]
    require(licenses == [ROOT / "LICENSE"], "project root must contain exactly one conventional license file, named LICENSE")
    text = regular_text(licenses[0], 1024 * 1024)
    prefix, separator, rest = text.partition("Permission is hereby granted")
    require(separator and re.fullmatch(r"MIT License\s+Copyright \(c\) .+", prefix.strip(), re.S),
            "LICENSE: expected the MIT title and a nonempty copyright notice")
    require(" ".join((separator + rest).split()) == " ".join(MIT_TERMS.split()),
            "LICENSE: terms do not exactly match the standard MIT text (ignoring whitespace)")


def check_sources(data):
    sources = data["sources"]
    for index, source in enumerate(sources):
        relation = source.get("relationship")
        require(relation in SOURCE_RELATIONSHIPS, f"sources[{index}].relationship: choose a current canonical relationship")
        require("type" not in source or source["type"] in SOURCE_TYPES, f"sources[{index}].type: unsupported source type")
        if relation == "other" or source.get("author_endorsement") == "other":
            require(bool(source.get("note", "").strip()), f"sources[{index}]: explain 'other' in note")
        for contributor in source.get("contributors", []):
            require(len(contributor["role"]) <= 200, f"sources[{index}].contributors: role exceeds 200 characters")
    original = any(s.get("type") == "original-proof" for s in sources)
    if original:
        require(all(s["relationship"] in {"background", "other"} for s in sources),
                "original-proof cannot be combined with formalizes/adapts/independently-proves")
        require(all(s["relationship"] == "other" for s in sources if s.get("type") == "original-proof"),
                "an original-proof source must have relationship: other")
    else:
        require(any(s["relationship"] in {"formalizes", "adapts", "independently-proves"} for s in sources),
                "source-based metadata requires a formalizes/adapts/independently-proves source")
    # This repository contains the proof, so no wrapper relationship should be claimed.
    require("repository" not in data, "omit repository: this is the substantive formalization, not a thin wrapper")
    require("provenance" not in data, "omit obsolete provenance; result origin is derived from sources")
    return "original" if original else "source-based"


def validate(path, offline=False):
    data = yaml.load(regular_text(path, 256 * 1024), Loader=StrictLoader)
    check_filled(data)
    schema_bytes = SCHEMA.read_bytes()
    require(hashlib.sha256(schema_bytes).hexdigest() == SCHEMA_SHA256, "vendored official schema: digest mismatch")
    schema = json.loads(schema_bytes)
    Draft7Validator.check_schema(schema)
    errors = sorted(Draft7Validator(schema).iter_errors(data), key=lambda e: str(list(e.absolute_path)))
    require(not errors, "schema validation failed:\n" + "\n".join(
        f"  {'.'.join(map(str, e.absolute_path)) or '$'}: {e.message}" for e in errors))
    require(data.get("version") == "v0.4", "version must be explicitly v0.4")
    project = data["project"]
    require(len(project["name"]) <= 300, "project.name exceeds 300 characters")
    require(isinstance(project.get("description"), str) and 0 < len(project["description"].strip()) <= 10000,
            "project.description must contain 1–10000 characters")
    maintainers = project.get("responsible_maintainers")
    require(isinstance(maintainers, list) and len(maintainers) > 0,
            "project.responsible_maintainers must be a nonempty list of human names")
    check_license(data)
    check_classification(data, offline)
    origin = check_sources(data)
    return origin


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("metadata", nargs="?", type=Path, default=ROOT / "formalization.yaml")
    parser.add_argument("--offline", action="store_true", help="require the pinned taxonomy files already in .tools cache")
    args = parser.parse_args()
    try:
        origin = validate(args.metadata, args.offline)
    except (OSError, ValueError, yaml.YAMLError) as error:
        print(f"metadata validation failed: {error}", file=sys.stderr)
        return 1
    print(f"Local metadata checks passed: v0.4, SPDX MIT, origin={origin}; no registry submission performed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
