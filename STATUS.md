# Status

The proof development is complete: the Lean library and its public submission
wrapper compile with no admitted proofs or unproved literature dependencies.
The correspondence with [paper/nivat.tex](paper/nivat.tex) has been reviewed by
AI agents and checked through expanded theorem statements. No human expert
review or mathematical digestion is claimed.

The public repository is [boonsuan/nivat](https://github.com/boonsuan/nivat).
It is prepared for submission to Palomar; no submission or registration has
been performed. The additional submission-check results and procedure are recorded in
[docs/PALOMAR.md](docs/PALOMAR.md).

## Public results

- `NivatSubmission.nivat`: the independent, fully expanded statement in
  `Challenge.lean`, proved in `Solution.lean` using the public library theorem.
- `Nivat.nivat`: Theorem 1.1, for every finite alphabet on the full integer
  lattice, with the original all-translation rectangle complexity and a
  nonzero global period.
- `Nivat.nivat_rational`: the strong area induction of Section 6, ranging over
  all finite rational alphabets.
- `Nivat.two_factors`: Theorem 5.1, including parallel directions.
- `Nivat.two_factors_nonparallel`: its directional conclusion, producing a
  nonzero integer multiple of one of the supplied directions as a period.
- `Nivat.Descent.exact_complexity_descent` and
  `Nivat.Descent.exists_smaller_low_complexity_rectangle`: Theorem 2.2 and
  Corollary 2.3, using the explicit transpose and full-kernel identities.
- `Nivat.difference_eq_zero_of_iterate_of_bounded`: bounded Lemma 3.4.
- `Nivat.Dynamics.exists_tangent_period_of_nonzero_annihilator`: Proposition 3.5.
- `Nivat.Algebra.exact_line_in_basis`: the normalized lattice-coordinate form
  of Theorem 4.1, giving the entire annihilator ideal.
- `Nivat.Algebra.exists_product_differences_of_annihilator`: Proposition 3.3,
  proved by Appendix A's arithmetic and interpolation argument.

The [statement map](docs/SOURCE_MAP.md) lists all main interfaces, and the
[reading guide](docs/READING_GUIDE.md) explains their representations. Every one
of the 377 explicit declarations in the 29 project modules has a mathematical
docstring identifying its paper location. Every cited LaTeX label resolves.

## Observed verification

`bash scripts/verify.sh --clean` completed with exit code 0. It rebuilt all
29 library modules and the separate `Solution` module, retaining the pinned
dependency cache. `lake build` finished successfully with 2502 jobs and no
warnings. The default build excludes the independent Challenge, whose single
intentional statement placeholder is not a proof-development gap.

A final incremental `bash scripts/verify.sh` run also completed with exit code 0.
The script ran these commands successfully:

```sh
lake build
lake env lean scripts/Audit.lean
python3 scripts/check_axioms.py scripts/Audit.lean logs/axioms.log
lake env lean scripts/RawStatements.lean
python3 scripts/check_axioms.py scripts/RawStatements.lean logs/raw-statements.log
lake env leanchecker --verbose Nivat
lake env leanchecker --verbose Solution
python3 scripts/source_audit.py
```

All 36 principal axiom reports and both fully expanded audit statements contain
exactly `propext`, `Classical.choice`, and `Quot.sound`. The final theorem's
fully elaborated type and its lattice, rectangle, pattern, complexity and
period definitions were inspected. All 59 declarations named in the statement
map also resolved in a separate Lean check.

Kernel replay passed for all 29 library modules and the separate Solution
module. This uses Lean's own kernel implementation and the imported dependency
environment; the independent Comparator/NanoDa procedure has a separate report in
[docs/PALOMAR.md](docs/PALOMAR.md). Library source checks found no proof
placeholders or additional trust mechanisms. The Challenge’s deliberate hole
is confined to the separate statement specification. The import graph is acyclic,
and the two-factor branch imports only Core and TwoFactors modules.

## Local submission checks

The pinned Comparator accepted the exact Challenge/Solution statement and its
axiom dependencies. The genuine independent NanoDa checker and Comparator’s
Lean kernel replay both accepted the Solution export. The command
`bash scripts/palomar_check.sh --development-unsandboxed` exited 0 on this Mac.
This was explicitly unsandboxed macOS development verification; no Linux
confinement or Palomar service check is claimed. The theorem statement and proof
sources remained unchanged during the check.

`.tools/metadata-venv/bin/python scripts/validate_metadata.py` and its `--offline`
variant passed the pinned v0.4 schema and local Palomar requirements, including
the MIT license, classifications, and source relationships. Seventeen targeted
negative checks of the validator passed. The CI workflow was checked locally
for YAML and shell syntax. Remote outcomes are recorded in
[GitHub Actions](https://github.com/boonsuan/nivat/actions/workflows/ci.yml).

There are no unresolved Lean proof obligations. The maintainer has authorized
GitHub publication and preparation of the Palomar form. The form must remain
unsubmitted for the maintainer to review and submit personally. Palomar intake,
editorial review, and registration have not been performed.

## Reproducibility and evidence

Lean is pinned to `leanprover/lean4:v4.33.1`; mathlib is pinned to
`0df444a360eaa60ab8c11dca51a86af692955474`. The manifest locks transitive
revisions. Exact observed versions are in [docs/versions.json](docs/versions.json).

- [Clean build](logs/clean-build.log)
- [Theorem types and axiom reports](logs/axioms.log)
- [Principal axiom allowlist](logs/axiom-allowlist.log)
- [Fully expanded statements](logs/raw-statements.log)
- [Expanded-statement axiom allowlist](logs/raw-axiom-allowlist.log)
- [Library kernel replay](logs/kernel-replay.log)
- [Submission Solution kernel replay](logs/solution-kernel-replay.log)
- [Documentation and import audit](logs/source-audit.log)
- [Source hashes and declaration inventory](logs/source-manifest.json)
- [Statement-map declaration checks](logs/map-check.log)
- [Complete verification output](logs/verification.log)

- [Local metadata validation](logs/metadata-validation.log)
- [Comparator and independent NanoDa result](logs/palomar-check.log)
- [Actual Comparator and kernel output](logs/palomar-output.log)
- [Comparator source hashes and result data](logs/palomar-check.json)
- [Pinned checker builds and binary hashes](logs/palomar-tools.json)
- [Paper PDF build and visual review](logs/paper-build.log): `latexmk` produced the 13-page `paper/nivat.pdf`; all pages were inspected and the TeX source was unchanged.
