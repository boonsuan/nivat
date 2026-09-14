import Nivat.Core.Alphabet
import Nivat.Algebra.ExactLine
import Nivat.Descent.ExactDescent
import Nivat.Dynamics.PeriodicDifference
import Nivat.TwoFactors.Main

/-!
# Proof of Nivat's conjecture

Theorem 1.1 (`thm:main`) and its proof in Section 6 of `paper/nivat.tex`.

`nivat_rational` carries out strong induction over rectangle area. The exact
line ideal gives the smaller low-complexity rectangle of Corollary 2.3, and
`periodic_of_periodic_line_filter` returns from the filtered configuration using
Theorem 5.1. `nivat` then transfers periods through a rational alphabet labeling.
-/

namespace Nivat

open Nivat.Algebra

/-- A divisor of the period polynomial evaluates to a nonzero line filter.
This verifies the filter hypothesis in the proof of Theorem 1.1, Section 6. -/
private theorem line_filter_ne_zero_of_period_divisor (v : Lattice) (hv : v ≠ 0)
    (q : ℕ) (hq : 0 < q) (φ : Polynomial ℚ) (hdiv : φ ∣ Polynomial.X ^ q - 1) :
    lineEval v φ ≠ 0 := by
  have hdiv' : lineEval v φ ∣ monomial (q • v) - 1 := by
    simpa only [lineEval_X_pow_sub_one] using lineEval_dvd v hdiv
  intro hz
  rw [hz, zero_dvd_iff] at hdiv'
  exact monomial_sub_one_ne_zero (smul_ne_zero (Nat.ne_of_gt hq) hv) hdiv'

/-- The polynomial-quotient step in Section 6. If the line-filtered configuration
is periodic, divisibility by `Z^q - 1` gives a mixed-difference identity;
Theorem 5.1 then makes the original low-complexity configuration periodic. -/
theorem periodic_of_periodic_line_filter (c : Configuration ℚ) (hc : FiniteRange c)
    (m n : ℕ) (hm : 0 < m) (hn : 0 < n)
    (hlow : complexity c (rectangle m n) ≤ m * n)
    (v : Lattice) (hv : v ≠ 0) (q : ℕ) (hq : 0 < q)
    (φ : Polynomial ℚ) (hdiv : φ ∣ Polynomial.X ^ q - 1)
    (hfiltered : Periodic (act (lineEval v φ) c)) : Periodic c := by
  obtain ⟨t, ht, hperiod⟩ := hfiltered
  obtain ⟨ψ, hψ⟩ := hdiv
  have hkill : difference t (act (lineEval v φ) c) = 0 :=
    (difference_eq_zero_iff t _).mpr hperiod
  have hmix : difference (q • v) (difference t c) = 0 := by
    rw [difference_comm]
    rw [← act_lineEval_X_pow_sub_one v q c, hψ, map_mul,
      mul_comm (lineEval v φ) (lineEval v ψ), act_mul,
      ← act_difference_comm, hkill, act_config_zero]
  exact two_factors c hc m n hm hn (q • v) t
    (smul_ne_zero (Nat.ne_of_gt hq) hv) ht hlow hmix

/-- The rational form of Theorem 1.1 (`thm:main`), proved in Section 6.
Strong induction runs over rectangle area and all finite rational ranges, so
it applies to the alphabet produced by each Laurent filter. -/
theorem nivat_rational (c : Configuration ℚ) (hc : FiniteRange c)
    (m n : ℕ) (hm : 0 < m) (hn : 0 < n)
    (hlow : complexity c (rectangle m n) ≤ m * n) : Periodic c := by
  classical
  have hmain (N : ℕ) :
      ∀ (c : Configuration ℚ), FiniteRange c →
      ∀ (m n : ℕ), m * n = N → 0 < m → 0 < n →
        complexity c (rectangle m n) ≤ m * n → Periodic c := by
    induction N using Nat.strong_induction_on with
    | h N ih =>
      intro c hc m n harea hm hn hlow
      by_cases hp : Periodic c
      · exact hp
      -- Lemma 3.2 and Corollary 3.6 produce the one-sided difference.
      obtain ⟨f, hf, hfann⟩ := exists_nonzero_annihilator c hc (rectangle m n)
        (by simpa only [card_rectangle] using hlow)
      obtain ⟨x, y, e, q, _hxfin, _hyfin, hx, hy, hd, hq, hperiod, hbelow⟩ :=
        Dynamics.periodic_difference_of_nonzero_annihilator c hc hp f hf hfann
      -- Theorem 4.1 gives the exact line generator required by Corollary 2.3.
      obtain ⟨φ, _hmonic, _hdegree, hdiv, hexact⟩ :=
        exact_line_in_basis e hd hq hperiod hbelow
      have hv : e (1, 0) ≠ 0 := by
        intro hz
        have h := e.injective (hz.trans e.map_zero.symm)
        exact (show ((1, 0) : Lattice) ≠ 0 by decide) h
      let Φ := lineEval (e (1, 0)) φ
      have hΦ : Φ ≠ 0 := line_filter_ne_zero_of_period_divisor (e (1, 0)) hv q hq φ hdiv
      obtain ⟨m', n', hm', hn', hsmall, hlow'⟩ :=
        Descent.exists_smaller_low_complexity_rectangle c hc x y hx hy hd Φ hΦ hexact m n hlow
      have hfiltered : Periodic (act Φ c) :=
        ih (m' * n') (by omega) (act Φ c) (finiteRange_act Φ hc) m' n' rfl hm' hn' hlow'
      exact periodic_of_periodic_line_filter c hc m n hm hn hlow
        (e (1, 0)) hv q hq φ hdiv hfiltered
  exact hmain (m * n) c hc m n rfl hm hn hlow

/-- Theorem 1.1 (`thm:main`): a finite-alphabet configuration with a low-complexity
positive rectangle has one nonzero global period. The proof in Section 6
transfers the rational theorem through the injective labeling of Section 1.1. -/
theorem nivat {A : Type*} [Finite A] (c : Configuration A)
    (m n : ℕ) (hm : 0 < m) (hn : 0 < n)
    (hlow : complexity c (rectangle m n) ≤ m * n) :
    ∃ h : Lattice, h ≠ 0 ∧ ∀ z : Lattice, c (z + h) = c z := by
  obtain ⟨d, hd, hcomplexity, hperiod⟩ := exists_rational_model c
  obtain ⟨h, hh, hp⟩ := nivat_rational d hd m n hm hn
    (by rw [hcomplexity]; exact hlow)
  exact ⟨h, hh, (hperiod h).mp hp⟩

end Nivat
