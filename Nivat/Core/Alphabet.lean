import Nivat.Core.Patterns
import Mathlib.Data.Fintype.EquivFin
import Mathlib.Data.Rat.Cast.Order

/-!
# Rational labels for a finite alphabet

The reduction in Section 1.1, used in Section 6 to prove Theorem 1.1 (`thm:main`).
`exists_rational_model` preserves all pattern counts and all individual periods.
-/

namespace Nivat

/-- An injective rational labeling of a finite alphabet (Section 1.1). -/
noncomputable def rationalLabel (A : Type*) [Finite A] : A ↪ ℚ := by
  letI := Fintype.ofFinite A
  exact
    { toFun := fun a => ((Fintype.equivFin A a).val : ℚ)
      inj' := fun a b h => (Fintype.equivFin A).injective
        (Fin.ext (Nat.cast_injective h)) }

/-- The rational alphabet reduction in Section 1.1 and the proof of Theorem 1.1
in Section 6: the labeling preserves every pattern count and every period vector. -/
theorem exists_rational_model {A : Type*} [Finite A] (c : Configuration A) :
    ∃ d : Configuration ℚ, FiniteRange d ∧
      (∀ D : Finset Lattice, complexity d D = complexity c D) ∧
      (∀ h : Lattice, IsPeriod d h ↔ IsPeriod c h) := by
  refine ⟨rationalLabel A ∘ c, (finiteRange_of_finite c).map _, ?_, ?_⟩
  · intro D
    exact complexity_map c (rationalLabel A).injective D
  · intro h
    exact isPeriod_map_iff c (rationalLabel A).injective h

end Nivat
