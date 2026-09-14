import Mathlib.Data.Set.Card
import Mathlib.Data.Int.Interval
import Mathlib.Data.Int.ConditionallyCompleteOrder
import Mathlib.Data.Finset.Prod
import Mathlib.Algebra.Group.Prod

/-!
# Nivat's conjecture: independent statement for comparison

For a finite alphabet, a configuration on the full integer lattice with at most
`m * n` distinct patterns on some positive `m`-by-`n` axis-aligned rectangle has
a nonzero global period. The pattern set below ranges over every integer
translation of that original rectangle; occurrences are counted only once.
The finite alphabet and finite rectangle make this pattern set finite, so its
natural cardinality has the intended counting meaning. The conclusion requires
one period vector, not two independent periods.

This statement uses only Mathlib definitions. The deliberate proof hole is the
Challenge convention for Comparator; the separately compiled `Solution` module
states the same theorem and supplies its proof from `Nivat.nivat`.
-/

namespace NivatSubmission

universe u

/-- Theorem 1.1 (`thm:main`) of `paper/nivat.tex`: Nivat's conjecture, with the
alphabet, rectangle, translations, pattern count, and single nonzero global
period all explicit. -/
theorem nivat {A : Type u} [Finite A] (c : (ℤ × ℤ) → A)
    (hlow : ∃ m n : ℕ, 0 < m ∧ 0 < n ∧
      (Set.range (fun t : ℤ × ℤ =>
        fun z : (Finset.Ico (0 : ℤ) (m : ℤ)).product
          (Finset.Ico (0 : ℤ) (n : ℤ)) =>
            c (z.1 + t))).ncard ≤ m * n) :
    ∃ h : ℤ × ℤ, h ≠ (0, 0) ∧
      ∀ z : ℤ × ℤ, c (z + h) = c z := by
  sorry

end NivatSubmission
