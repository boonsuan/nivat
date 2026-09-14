import Nivat.Main

/-!
# Proof of the independent Nivat statement

This module is compiled separately from `Challenge`. Its theorem has the same
fully expanded statement and is proved by the public finite-alphabet theorem.
It does not import the Challenge or its deliberate proof hole.
-/

namespace NivatSubmission

universe u

/-- Theorem 1.1 (`thm:main`) of `paper/nivat.tex`, proved from `Nivat.nivat`: the
corresponding proof of the independent Challenge statement on the full integer
lattice. -/
theorem nivat {A : Type u} [Finite A] (c : (ℤ × ℤ) → A)
    (hlow : ∃ m n : ℕ, 0 < m ∧ 0 < n ∧
      (Set.range (fun t : ℤ × ℤ =>
        fun z : (Finset.Ico (0 : ℤ) (m : ℤ)).product
          (Finset.Ico (0 : ℤ) (n : ℤ)) =>
            c (z.1 + t))).ncard ≤ m * n) :
    ∃ h : ℤ × ℤ, h ≠ (0, 0) ∧
      ∀ z : ℤ × ℤ, c (z + h) = c z := by
  obtain ⟨m, n, hm, hn, hcomplexity⟩ := hlow
  exact Nivat.nivat c m n hm hn hcomplexity

end NivatSubmission
