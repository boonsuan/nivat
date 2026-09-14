# Pinned metadata schema

`formalization.v0.4.schema.json` is an unmodified copy of the official
[`formalization.yaml` v0.4 schema](https://github.com/mathlib-initiative/formalization.yaml/blob/99c678e569c7c4c0772db297c5ddd5e4c9b6322e/schema/v0.4.schema.json),
at commit `99c678e569c7c4c0772db297c5ddd5e4c9b6322e`.
Its SHA-256 is
`25ff6b25ca4511635aff4443cf20480c15e59dddf19591c730950b442ea54fce`.
The upstream Apache-2.0 license is preserved in
`LICENSE.formalization-schema`; it applies to this third-party schema.

`scripts/validate_metadata.py` checks the schema and a selected local subset of
[Palomar's contribution policy](https://github.com/PalomarRegistry/PalomarPolicy/blob/e9c8c238f5695b10f75db7175648a1d0195352c1/CONTRIBUTING.md),
including classification membership, responsible maintainers, coherent source
relationships, and the repository's chosen MIT license. It rejects duplicate
YAML keys, merge keys, empty text fields, and obvious template markers.

Taxonomies are fetched from PalomarSubmission commit
`ef2fa1eadcb246c2346ddba39b52eaa53d4bb763` into the ignored
`.tools/metadata/taxonomies/` cache and checked against pinned SHA-256 digests.
They are not vendored into the MIT project. Their source and licensing are
recorded in the upstream [taxonomy directory](https://github.com/PalomarRegistry/PalomarSubmission/tree/ef2fa1eadcb246c2346ddba39b52eaa53d4bb763/taxonomies).
After one successful run, `--offline` uses only those cached files.

Run the validator with the packages in `requirements-checks.txt`:

```sh
python3 scripts/validate_metadata.py
```

This is a local metadata check. It does not check submitter authorization,
human identity or authorship, mathematical relevance, registry eligibility,
public repository availability, or publication status. It neither submits nor
registers anything. Lean proof validation is performed by the separate audit
and Comparator scripts.
