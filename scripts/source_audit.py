#!/usr/bin/env python3
"""Check project imports, explicit-declaration documentation and paper references."""
from bisect import bisect_right
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent.parent
DECLARATION = re.compile(
    r'^[ \t]*(?:@\[[^\n]*?\][ \t]*)?'
    r'(?:(?:private|protected|noncomputable|unsafe)[ \t]+)*'
    r'(?P<kind>def|abbrev|theorem|lemma|structure|class|instance)[ \t]+'
    r'(?P<name>[\w.]+)', re.M
)


def mask_comments_and_strings(text):
    """Preserve source positions while removing comments and string contents."""
    masked = list(text)
    comments = []
    i = 0
    while i < len(text):
        start = i
        if text.startswith('/-', i):
            is_doc = text.startswith('/--', i)
            depth = 1
            i += 2
            while depth and i < len(text):
                if text.startswith('/-', i):
                    depth += 1
                    i += 2
                elif text.startswith('-/', i):
                    depth -= 1
                    i += 2
                else:
                    i += 1
            if depth:
                raise ValueError('Unclosed Lean comment')
            comments.append((start, i, text[start:i], is_doc))
        elif text.startswith('--', i):
            end = text.find('\n', i)
            i = len(text) if end < 0 else end
        elif text[i] == '"':
            i += 1
            while i < len(text):
                if text[i] == '\\':
                    i += 2
                elif text[i] == '"':
                    i += 1
                    break
                else:
                    i += 1
        else:
            i += 1
            continue
        masked[start:i] = ['\n' if c == '\n' else ' ' for c in text[start:i]]
    return ''.join(masked), comments


def main():
    paths = [ROOT / 'Nivat.lean', *sorted((ROOT / 'Nivat').rglob('*.lean'))]
    modules = {str(p.relative_to(ROOT).with_suffix('')).replace('/', '.'): p for p in paths}
    labels = set(re.findall(r'\\label\{([^}]+)\}', (ROOT / 'paper/nivat.tex').read_text()))
    imports, inventory, errors = {}, [], []
    forbidden = re.compile(r'\b(sorry|admit|axiom|native_decide|unsafe|implemented_by|extern)\b'
                           r'|skipKernelTC|trustLevel|Lean\.ofReduceBool')
    for module, path in modules.items():
        text = path.read_text()
        code, comments = mask_comments_and_strings(text)
        relative = str(path.relative_to(ROOT))
        imports[module] = [m for m in re.findall(r'^import\s+(\S+)', code, re.M)
                           if m == 'Nivat' or m.startswith('Nivat.')]
        if any(m not in modules for m in imports[module]):
            errors.append(f'{relative}: missing project import')
        if '/-!' not in text:
            errors.append(f'{relative}: missing module documentation')
        for match in forbidden.finditer(code):
            errors.append(f'{relative}: disallowed source token {match[0]}')
        docs = [comment for comment in comments if comment[3]]
        ends = [comment[1] for comment in docs]
        for match in DECLARATION.finditer(code):
            line = text.count('\n', 0, match.start()) + 1
            index = bisect_right(ends, match.start()) - 1
            doc = docs[index][2] if index >= 0 else ''
            gap = code[ends[index]:match.start()] if index >= 0 else 'missing'
            gap = re.sub(r'@\[[^\]]*\]', '', gap)
            if gap.strip() or not doc:
                errors.append(f'{relative}:{line}: missing docstring for {match["name"]}')
            if not re.search(r'Section|Theorem|Lemma|Corollary|Proposition|Appendix|eq:', doc, re.I):
                errors.append(f'{relative}:{line}: missing paper location for {match["name"]}')
            references = re.findall(r'`((?:sec|app|thm|lem|prop|cor|eq|ex):[^`]+)`', doc)
            for reference in references:
                if reference not in labels:
                    errors.append(f'{relative}:{line}: unknown paper label {reference}')
            inventory.append({'file': relative, 'line': line, 'kind': match['kind'],
                              'name': match['name'], 'paper_labels': references})

    def closure(module, active=frozenset()):
        if module in active:
            raise ValueError(f'Project import cycle at {module}')
        result = {module}
        for dependency in imports[module]:
            result |= closure(dependency, active | {module})
        return result

    if closure('Nivat') != set(modules):
        errors.append('Public import does not cover every project module')
    branch = closure('Nivat.TwoFactors.Main')
    if any(not m.startswith(('Nivat.Core.', 'Nivat.TwoFactors.')) for m in branch):
        errors.append('Two-factor branch depends on the descent or final theorem')
    if errors:
        raise SystemExit('\n'.join(errors))
    manifest = {
        'sha256': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths},
        'project_imports': imports, 'two_factor_closure': sorted(branch), 'declarations': inventory
    }
    (ROOT / 'logs').mkdir(exist_ok=True)
    (ROOT / 'logs/source-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(f'All {len(modules)} project modules are covered by the acyclic root import.')
    print(f'All {len(inventory)} explicit declarations have docstrings with paper locations.')
    print('All cited LaTeX labels exist in paper/nivat.tex.')
    print('No proof placeholders or additional trust mechanisms found in project source.')
    print('Two-factor project imports are confined to Core and TwoFactors:')
    print('\n'.join(sorted(branch)))
    print('These source checks supplement the Lean build, theorem-type audit and kernel replay.')


if __name__ == '__main__':
    main()
