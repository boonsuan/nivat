import Nivat.Main

/-!
Raw semantic audit statements. These expand the lattice, rectangle, pattern
count, and global-period conclusion directly in the public theorem types.
The only project declarations used in their proofs are the public endpoints
and the checked definition of the forward difference.
-/

namespace NivatAudit

universe u

/-- Theorem 1.1 (`thm:main`) with its rectangle, pattern count and period fully expanded. -/
theorem finite_alphabet_rectangle_period {A : Type u} [Finite A]
    (c : (ℤ × ℤ) → A)
    (hlow : ∃ m n : ℕ, 0 < m ∧ 0 < n ∧
      (Set.range (fun t : ℤ × ℤ =>
        fun z : (Finset.Ico (0 : ℤ) (m : ℤ)).product
          (Finset.Ico (0 : ℤ) (n : ℤ)) =>
            c (z.1 + t))).ncard ≤ m * n) :
    ∃ h : ℤ × ℤ, h ≠ (0, 0) ∧
      ∀ z : ℤ × ℤ, c (z + h) = c z := by
  obtain ⟨m, n, hm, hn, hcomplexity⟩ := hlow
  exact Nivat.nivat c m n hm hn hcomplexity

/-- Theorem 5.1 (`thm:twofactor`) with its mixed difference written as four values
of the original configuration. -/
theorem rational_mixed_difference_period (c : (ℤ × ℤ) → ℚ)
    (hc : (Set.range c).Finite) (m n : ℕ) (hm : 0 < m) (hn : 0 < n)
    (h t : ℤ × ℤ) (hh : h ≠ (0, 0)) (ht : t ≠ (0, 0))
    (hlow : (Set.range (fun u : ℤ × ℤ =>
      fun z : (Finset.Ico (0 : ℤ) (m : ℤ)).product
        (Finset.Ico (0 : ℤ) (n : ℤ)) =>
          c (z.1 + u))).ncard ≤ m * n)
    (hmix : ∀ z : ℤ × ℤ,
      c (z + h + t) - c (z + h) - (c (z + t) - c z) = 0) :
    ∃ v : ℤ × ℤ, v ≠ (0, 0) ∧
      ∀ z : ℤ × ℤ, c (z + v) = c z := by
  apply Nivat.two_factors c hc m n hm hn h t hh ht hlow
  funext z
  simpa [Nivat.difference_apply] using hmix z

end NivatAudit

#print axioms NivatAudit.finite_alphabet_rectangle_period
#print axioms NivatAudit.rational_mixed_difference_period
