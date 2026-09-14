# Nivat formalization

## Mathematical interfaces

The reference is `paper/nivat.tex`. Comments identify its section, statement
number and LaTeX label. Each declaration explains its mathematical role;
implementation helpers identify the proof they support.

Configurations live on `ℤ × ℤ`, with forward shifts. Complexity counts distinct
restrictions over every integer translation of the stated window. Use finite
range when interpreting natural set cardinality. `Periodic` requires one
nonzero global period. The main induction covers all finite rational ranges.

The two-factor branch imports only Core and TwoFactors modules. It must remain
independent of the descent and the final theorem.

## Code and documentation

Keep definitions and interfaces small and mathematical. Prefer mathlib lemmas
to duplicate infrastructure. Use private declarations for proof internals and
public declarations for useful mathematical interfaces. Remove unused wrappers
and redundant imports. Every declaration needs a useful docstring referring to
the paper; module comments describe the main results and reading order.

Preserve the exact final theorem during refactoring. Keep `README.md`,
`docs/SOURCE_MAP.md` and `STATUS.md` consistent with the checked code. The
mathematical source describes the mathematics and current implementation without
development history or provenance commentary. The README and submission metadata
must disclose AI generation, AI formalization, human roles, and review limitations
accurately; these disclosures are explicitly requested by the maintainer.

## Verification

Reuse the pinned Lean/mathlib environment. Build incrementally with Lake.
Run `bash scripts/verify.sh --clean` for a release build, type and axiom audits,
raw-statement checks, source documentation checks and kernel replay.

No admitted proof, project axiom, native-computation assertion, or kernel bypass
is permitted in the proof development. `Challenge.lean` is the sole exception:
Palomar's independent statement module deliberately leaves its theorem unproved.
It must never be imported by `Nivat` or `Solution`; the corresponding Solution
theorem must have a complete proof, checked by Comparator against the Challenge.
The allowed logical axioms are `propext`, `Classical.choice`, and
`Quot.sound`. Inspect definitions and the fully elaborated theorem type as well
as its axioms. Report only observed checks.

The public repository is `github.com/boonsuan/nivat`. The maintainer has
authorized publication and preparation of the Palomar submission form. Leave
the form unsubmitted for the maintainer to review and submit personally. Do not
initiate a Palomar submission or registration on the maintainer's behalf.
