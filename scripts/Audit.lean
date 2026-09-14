import Nivat
import Solution

/-!
Type and axiom audit of the main interfaces in paper order.
The final checks display the fully elaborated public type and its definitions.
-/

#check @Nivat.exists_rational_model
#print axioms Nivat.exists_rational_model

#check @Nivat.Algebra.act_mul
#print axioms Nivat.Algebra.act_mul

#check @Nivat.Algebra.finiteRange_act
#print axioms Nivat.Algebra.finiteRange_act

#check @Nivat.Algebra.support_mul_subset_rectangle_iff
#print axioms Nivat.Algebra.support_mul_subset_rectangle_iff

#check @Nivat.Descent.multiplierMap_injective
#print axioms Nivat.Descent.multiplierMap_injective

#check @Nivat.Descent.localFilter_transpose
#print axioms Nivat.Descent.localFilter_transpose

#check @Nivat.Descent.translatedSpan_eq_ker
#print axioms Nivat.Descent.translatedSpan_eq_ker

#check @Nivat.Descent.translatedSpan_finrank_add
#print axioms Nivat.Descent.translatedSpan_finrank_add

#check @Nivat.Descent.finite_fiber_budget
#print axioms Nivat.Descent.finite_fiber_budget

#check @Nivat.Descent.exact_complexity_descent
#print axioms Nivat.Descent.exact_complexity_descent

#check @Nivat.Descent.exists_smaller_low_complexity_rectangle
#print axioms Nivat.Descent.exists_smaller_low_complexity_rectangle

#check @Nivat.Dynamics.exists_halfPlane_pair
#print axioms Nivat.Dynamics.exists_halfPlane_pair

#check @Nivat.Dynamics.halfPlane_pair_of_finiteRange_not_periodic
#print axioms Nivat.Dynamics.halfPlane_pair_of_finiteRange_not_periodic

#check @Nivat.Algebra.exists_nonzero_annihilator
#print axioms Nivat.Algebra.exists_nonzero_annihilator

#check @Nivat.Algebra.exists_product_differences_of_annihilator
#print axioms Nivat.Algebra.exists_product_differences_of_annihilator

#check @Nivat.difference_eq_zero_of_iterate_of_bounded
#print axioms Nivat.difference_eq_zero_of_iterate_of_bounded

#check @Nivat.Dynamics.exists_tangent_period_of_nonzero_annihilator
#print axioms Nivat.Dynamics.exists_tangent_period_of_nonzero_annihilator

#check @Nivat.Dynamics.periodic_difference_of_nonzero_annihilator
#print axioms Nivat.Dynamics.periodic_difference_of_nonzero_annihilator

#check @Nivat.Algebra.exact_line_in_basis
#print axioms Nivat.Algebra.exact_line_in_basis

#check @Nivat.two_factors
#print axioms Nivat.two_factors

#check @Nivat.two_factors_nonparallel
#print axioms Nivat.two_factors_nonparallel

#check @Nivat.two_periodic_summands
#print axioms Nivat.two_periodic_summands

#check @Nivat.TwoFactors.periodic_of_deterministic_successor_bounded
#print axioms Nivat.TwoFactors.periodic_of_deterministic_successor_bounded

#check @Nivat.TwoFactors.morse_hedlund
#print axioms Nivat.TwoFactors.morse_hedlund

#check @Nivat.TwoFactors.periodic_of_periodic_forcing
#print axioms Nivat.TwoFactors.periodic_of_periodic_forcing

#check @Nivat.TwoFactors.exists_shapeWindow
#print axioms Nivat.TwoFactors.exists_shapeWindow

#check @Nivat.TwoFactors.ShapeWindow.normalize
#print axioms Nivat.TwoFactors.ShapeWindow.normalize

#check @Nivat.TwoFactors.boundaryRule_of_small_cost
#print axioms Nivat.TwoFactors.boundaryRule_of_small_cost

#check @Nivat.TwoFactors.finite_strip_dichotomy
#print axioms Nivat.TwoFactors.finite_strip_dichotomy

#check @Nivat.TwoFactors.common_inner_period
#print axioms Nivat.TwoFactors.common_inner_period

#check @Nivat.TwoFactors.periodic_of_rows_boundaryRule
#print axioms Nivat.TwoFactors.periodic_of_rows_boundaryRule

#check @Nivat.TwoFactors.directional_period_of_short_window
#print axioms Nivat.TwoFactors.directional_period_of_short_window

#check @Nivat.periodic_of_parallel_mixed_difference
#print axioms Nivat.periodic_of_parallel_mixed_difference

#check @Nivat.nivat_rational
#print axioms Nivat.nivat_rational

#check @Nivat.nivat
#print axioms Nivat.nivat

#check @NivatSubmission.nivat
#print axioms NivatSubmission.nivat

#print Nivat.Lattice
#print Nivat.Configuration
#print Nivat.FiniteRange
#print Nivat.shift
#print Nivat.difference
#print Nivat.Periodic
#print Nivat.IsPeriod
#print Nivat.patternAt
#print Nivat.patterns
#print Nivat.complexity
#print Nivat.rectangle

set_option pp.universes true in
set_option pp.explicit true in
#check @Nivat.nivat
#print Nivat.nivat
#print Nivat.nivat_rational

set_option pp.universes true in
set_option pp.explicit true in
#check @NivatSubmission.nivat
