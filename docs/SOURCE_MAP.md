# Paper-to-declaration map

The source is [paper/nivat.tex](../paper/nivat.tex). Statement numbers and LaTeX
labels below refer to that paper. All listed Lean names include their complete
namespace. Auxiliary declarations document the particular argument they support.

| Paper location | Main Lean declaration or definition |
| --- | --- |
| Section 1: configurations, periods and rectangles | `Nivat.Configuration`, `Nivat.IsPeriod`, `Nivat.Periodic`, `Nivat.rectangle` |
| Section 1: occurring patterns and complexity | `Nivat.patternAt`, `Nivat.patterns`, `Nivat.complexity` |
| Section 1.1: rational labeling | `Nivat.rationalLabel`, `Nivat.exists_rational_model` |
| Section 1.1: shifts and Laurent action | `Nivat.shift`, `Nivat.difference`, `Nivat.Laurent`, `Nivat.Algebra.act` |
| Section 1.1: discrepancy and lattice coordinates | `Nivat.discrepancy`, `Nivat.exists_lattice_basis_for_nonzero`, `Nivat.complexity_affine_reindex` |
| Section 1.1: orbit closure and inheritance (`eq:inheritance`) | `Nivat.Dynamics.orbitClosure`, `Nivat.Dynamics.act_eq_zero_of_origin_language` |
| Lemma 2.1 (`lem:supported`) | `Nivat.Algebra.support_mul_subset_rectangle_iff`, `Nivat.Descent.multiplierMap_injective` |
| Theorem 2.2, local filter and transpose (`thm:descent`) | `Nivat.Descent.localFilter`, `Nivat.Descent.multiplierMap`, `Nivat.Descent.localFilter_transpose` |
| Theorem 2.2, full kernel and dimension (`eq:full-kernel`, `eq:filter-dimension`) | `Nivat.Descent.translatedSpan_eq_ker`, `Nivat.Descent.translatedSpan_finrank_add` |
| Theorem 2.2, fiber count and conclusion (`eq:descent`) | `Nivat.Descent.finite_fiber_budget`, `Nivat.Descent.exact_complexity_descent` |
| Corollary 2.3 (`cor:line-descent`) | `Nivat.Descent.exists_smaller_low_complexity_rectangle`; geometry: `Nivat.Algebra.exists_smaller_rectangle_of_annihilator` |
| Lemma 3.1 (`lem:halfplane-pair`) | `Nivat.Dynamics.exists_halfPlane_pair`; finite-range language interface: `Nivat.Dynamics.halfPlane_pair_of_finiteRange_not_periodic` |
| Lemma 3.2 (`lem:ann-exists`) | `Nivat.Algebra.exists_affine_annihilator`, `Nivat.Algebra.exists_nonzero_annihilator` |
| Proposition 3.3 (`prop:product`) and Appendix A (`app:product`) | `Nivat.Algebra.exists_product_differences_of_annihilator` |
| Lemma 3.4 (`lem:repeated`) | `Nivat.difference_eq_zero_of_iterate_of_bounded`; finite-range specialization: `Nivat.difference_eq_zero_of_iterate` |
| Proposition 3.5 (`prop:tangent-period`) | `Nivat.Dynamics.exists_tangent_period_of_nonzero_annihilator` |
| Corollary 3.6 (`cor:periodic-difference`) | `Nivat.Dynamics.periodic_difference_of_nonzero_annihilator` |
| Theorem 4.1 (`thm:exact-ideal`) | `Nivat.Algebra.exact_horizontal_line`, `Nivat.Algebra.exact_line_in_basis` |
| Theorem 5.1 (`thm:twofactor`) | `Nivat.two_factors`, `Nivat.two_factors_nonparallel`; parallel case: `Nivat.periodic_of_parallel_mixed_difference` |
| Section 5: two periodic summands | `Nivat.two_periodic_summands` |
| Lemma 5.2 (`lem:finite-states`) | `Nivat.TwoFactors.periodic_of_deterministic_successor_bounded`, `Nivat.TwoFactors.periodic_of_deterministic_predecessor_bounded` |
| Corollary 5.3 (`cor:morse`) | `Nivat.TwoFactors.morse_hedlund` |
| Lemma 5.4 (`lem:forcing`) | `Nivat.TwoFactors.periodic_of_periodic_forcing` |
| Lemma 5.5 (`lem:boundary-window`) | `Nivat.TwoFactors.exists_shapeWindow`, `Nivat.TwoFactors.ShapeWindow.normalize`, `Nivat.TwoFactors.boundaryRule_of_small_cost` |
| Lemma 5.6 (`lem:strip-states`) | `Nivat.TwoFactors.finite_strip_dichotomy` |
| Lemma 5.7 (`lem:periodic-interior`) | `Nivat.TwoFactors.every_edge_differs`, `Nivat.TwoFactors.innerOrbit_budget`, `Nivat.TwoFactors.common_inner_period` |
| Lemma 5.8 (`lem:row-lifting`) | `Nivat.TwoFactors.periodic_of_rows_boundaryRule` |
| Section 6: quotient-polynomial step | `Nivat.periodic_of_periodic_line_filter` |
| Theorem 1.1 (`thm:main`), proved in Section 6 | `Nivat.nivat_rational`, `Nivat.nivat` |

## Forms of the interfaces

The descent theorem uses finite-pattern language inclusion, which the compactness
modules establish from orbit closure. The exact-ideal and tangent-period
interfaces package primitive coordinates as an additive lattice equivalence.
Corollary 2.3 uses the support-width form, valid for every nonzero exact filter of
a nonzero difference. These formulations make the hypotheses needed by the next
proof explicit.

The numbered examples and unnumbered illustrations explain the estimates; they
are not separate dependencies in the formal proof.
