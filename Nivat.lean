import Nivat.Main

/-!
# Pattern complexity and Nivat's conjecture

The formalization of `paper/nivat.tex`.

* `Nivat.nivat`: Theorem 1.1, proved in Section 6.
* `Nivat.nivat_rational`: its finite-range rational induction statement.
* `Nivat.two_factors`: Theorem 5.1.

The import graph follows mathematical dependencies. The two-factor theorem is
proved entirely within `Nivat.Core` and `Nivat.TwoFactors`.
-/
