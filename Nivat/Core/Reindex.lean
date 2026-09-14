import Nivat.Core.Patterns
import Mathlib.Algebra.Group.Equiv.Basic

/-!
# Affine lattice coordinates

Coordinate transport for Lemma 5.5 (`lem:boundary-window`) and Theorem 5.1
(`thm:twofactor`) in `paper/nivat.tex`.

A configuration and its window are transported together. The affine map `s`
acts on sites, while its additive part `t` acts on translation and period vectors.
-/

namespace Nivat

/-- Reindexing lattice sites preserves finite range (Section 1.1). -/
theorem FiniteRange.precomp {A : Type*} {c : Configuration A} (hc : FiniteRange c)
    (f : Lattice → Lattice) : FiniteRange (c ∘ f) := by
  apply hc.subset
  rintro a ⟨z, rfl⟩
  exact ⟨f z, rfl⟩

/-- Transport both a configuration and its window along affine lattice coordinates.
This is the basis-and-origin change in Lemma 5.5 (`lem:boundary-window`);
`s` is the affine bijection and `t` its linear part. -/
theorem complexity_affine_reindex {A : Type*} (c : Configuration A)
    (s : Lattice ≃ Lattice) (t : Lattice ≃+ Lattice)
    (hst : ∀ z u : Lattice, s (z + u) = s z + t u) (D : Finset Lattice) :
    complexity (c ∘ s) D = complexity c (D.map s.toEmbedding) := by
  symm
  apply Set.ncard_congr
    (fun p _ => fun z : D => p ⟨s z, Finset.mem_map.mpr ⟨z, z.2, rfl⟩⟩)
  · rintro p ⟨u, rfl⟩
    refine ⟨t.symm u, ?_⟩
    funext z
    simp [patternAt, hst]
  · intro p q _ _ hpq
    funext z
    obtain ⟨w, hw, heq⟩ := Finset.mem_map.mp z.2
    have h := congrFun hpq ⟨w, hw⟩
    convert h using 1 <;> congr 1 <;> exact Subtype.ext heq.symm
  · rintro p ⟨u, rfl⟩
    refine ⟨patternAt c (D.map s.toEmbedding) (t u), ⟨t u, rfl⟩, ?_⟩
    funext z
    simp [patternAt, hst]

/-- A period in affine coordinates transports through the linear part.
This is the return to the original lattice in Theorem 5.1 (`thm:twofactor`). -/
theorem isPeriod_affine_reindex_iff {A : Type*} (c : Configuration A)
    (s : Lattice ≃ Lattice) (t : Lattice ≃+ Lattice)
    (hst : ∀ z u : Lattice, s (z + u) = s z + t u) (h : Lattice) :
    IsPeriod (c ∘ s) h ↔ IsPeriod c (t h) := by
  constructor
  · intro hp z
    have hx := hp (s.symm z)
    simpa only [Function.comp_apply, hst, s.apply_symm_apply] using hx
  · intro hp z
    simpa only [Function.comp_apply, hst] using hp (s z)

/-- Difference operators transport with their lattice direction.
This is the mixed-difference coordinate change in Theorem 5.1 (`thm:twofactor`). -/
theorem difference_affine_reindex {A : Type*} [AddCommGroup A] (c : Configuration A)
    (s : Lattice ≃ Lattice) (t : Lattice ≃+ Lattice)
    (hst : ∀ z u : Lattice, s (z + u) = s z + t u) (h : Lattice) :
    difference h (c ∘ s) = difference (t h) c ∘ s := by
  funext z
  simp only [difference_apply, Function.comp_apply, hst]

end Nivat
