#!/usr/bin/env python3
"""Check the axiom reports requested by a Lean audit source against an allowlist."""
import argparse
from pathlib import Path
import re

ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}
REPORT = re.compile(
    r"'(?P<name>[\w.]+)' (?:depends on axioms: \[(?P<axioms>[^\]]*)\]"
    r"|(?P<none>does not depend on any axioms))"
)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path, help='Lean source containing #print axioms commands')
    parser.add_argument('log', type=Path, help='Output from running that source with Lean')
    args = parser.parse_args()
    names = re.findall(r'^#print axioms ([\w.]+)\s*$', args.source.read_text(), re.M)
    text = args.log.read_text()
    if not names or len(names) != len(set(names)):
        raise SystemExit('Audit must request a nonempty list of distinct declarations.')
    if re.search(r'\berror:|\bwarning:[^\n]*(?:sorry|admit)', text):
        raise SystemExit('Lean audit log contains an error or proof-hole warning.')
    reports = {}
    for match in REPORT.finditer(text):
        name = match['name']
        if name in reports:
            raise SystemExit(f'Duplicate axiom report: {name}')
        reports[name] = set(filter(None, map(str.strip, (match['axioms'] or '').split(','))))
    if set(reports) != set(names):
        raise SystemExit(f'Report mismatch: {set(reports) ^ set(names)}')
    for name in names:
        unexpected = reports[name] - ALLOWED
        if unexpected:
            raise SystemExit(f'{name}: disallowed axioms {sorted(unexpected)}')
        print(f'{name}: {sorted(reports[name])}')
    print(f'Allowed axiom dependencies confirmed for {len(names)} declarations.')
    print('This screens Lean output; it does not replace kernel checking or statement inspection.')


if __name__ == '__main__':
    main()
