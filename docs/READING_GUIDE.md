# Reading the formalization

The reference is [Pattern complexity and Nivat's conjecture](../paper/nivat.tex).
Module docstrings name their main results. Declaration docstrings distinguish a
numbered result from an auxiliary step in its proof; LaTeX labels locate the
corresponding statement or equation precisely.

## Notation and representations

`Configuration A` is the full function type `(ℤ × ℤ) → A`. The finite-range
condition concerns its values, never its domain. `IsPeriod c h` is pointwise
translation invariance and permits zero; `Periodic c` requires a nonzero witness.

`patternAt c D u` is a function on the finite subtype `D`, and `patterns c D`
is its range as `u` varies over the whole lattice. `complexity` takes the natural
cardinality of that set. Its interpretation is justified by `patterns_finite`.
Signed discrepancy uses integers. Cardinal inequalities in the proofs are often
written additively to avoid truncated natural subtraction.

`Laurent` is mathlib's additive monoid algebra of `ℤ × ℤ` over `ℚ`. The coefficient
support is finite, while the configuration on which the polynomial acts need
not be finitely supported. `Algebra.act` uses forward shifts. The statement
`∀ f, act f d = 0 ↔ Φ ∣ f` expresses the ideal equality `Ann(d) = (Φ)`.

An additive equivalence of the integer lattice packages a lattice basis.
Affine normalization separates the map on sites from its linear action on
translation vectors. The exact transported window is retained: an oblique
image is never silently treated as an axis-aligned rectangle.

## The descent argument

`Algebra.support_mul_subset_rectangle_iff` proves the geometric part of
Lemma 2.1. `Descent.multiplierMap` represents multiplication on supported
polynomials, and its injectivity supplies the dimension calculation.

The local filter acts on a finite rectangular pattern. Its transpose is
multiplication by `Φ` (`localFilter_transpose`). The exact annihilator hypothesis
identifies the perpendicular space of the translated difference patterns, so
`translatedSpan_eq_ker` gives equation `eq:full-kernel`. The general finite-set
lemma `finite_fiber_budget` then turns this dimension into a pattern-count loss.

`exact_complexity_descent` is Theorem 2.2. Its language-inclusion hypotheses are
the finite-pattern consequence of orbit-closure membership needed in that proof.
`exists_smaller_low_complexity_rectangle` gives Corollary 2.3. Nonemptiness comes
from the pattern count; support widths give a strictly smaller rectangle in the
original coordinate axes.

## Constructing the exact filter

`Dynamics.HalfPlanePair` performs the compactness argument of Lemma 3.1.
`OrbitClosure` proves the finite-pattern inheritance and handles finite rational
range through a discrete finite subtype. The pointwise topology on all rationals
is not changed.

`PeriodicDifference` cancels transverse factors on configurations vanishing
below some normal level. Its direct tangent-period theorem is Proposition 3.5;
Corollary 3.6 then inherits the original annihilator onto the difference of the
two closure points. `Core.BoundedDifferences` proves the bounded version of
Lemma 3.4, with finite-range specializations for these applications.

`Algebra.ExactLine` proves Theorem 4.1 in normalized lattice coordinates.
The first nonzero row and Bézout's identity rule out transverse relations.
Degree induction removes irreducible factors while preserving multiplicities;
the endpoint is the full Laurent annihilator equivalence, not only an exhibited
annihilator. `ProductDifferences` supplies Proposition 3.3 by Appendix A's integer
scaling, prime dilation and Laurent interpolation argument.

## The two-factor argument and final induction

The `TwoFactors` modules contain only the mathematics of Section 5. Finite
states and Morse–Hedlund give periods from a word-complexity bound. Window
selection supplies an actual boundary rule; strip ambiguity bounds the common
interior word complexity. Periodic forcing extends enough row periods to fill
one transverse orbit band. Only finitely many row periods are combined.

`two_factors_nonparallel` preserves the directional conclusion of Theorem 5.1:
a nonzero integer multiple of one of the two supplied vectors is a period.
`two_factors` combines this with the parallel case. This branch imports no
algebraic descent, half-plane construction or final theorem.

`Main.lean` follows Section 6. The induction quantifies over every finite-range
rational configuration at each area. After Corollary 2.3, it applies to the
filtered alphabet. Multiplication by the quotient of `Z^q - 1` produces the
mixed difference, and Theorem 5.1 applies to the original rectangle. The rational
labeling transfers the resulting period to an arbitrary finite alphabet.
