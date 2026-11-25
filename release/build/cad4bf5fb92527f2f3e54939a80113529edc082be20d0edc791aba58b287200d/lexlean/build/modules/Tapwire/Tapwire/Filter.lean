module
public import Init
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Tapwire.Tapwire.Filter

public inductive ComparisonOp where
  | equal
  | greaterThan
  | lessThan

public inductive FilterExpr where
  | literal (_ : Nat)
  | comparison (_ : ComparisonOp) (_ : Nat) (_ : Nat)
  | conjunction (_ : FilterExpr) (_ : FilterExpr)
  | negation (_ : FilterExpr)

@[expose] public def evaluateFilter : (expression : FilterExpr) -> Bool
  | FilterExpr.literal value => (Nat.blt (0) (value))
  | FilterExpr.comparison op left right => (match op with | ComparisonOp.equal => (Nat.beq (left) (right)) | ComparisonOp.greaterThan => (Nat.blt (right) (left)) | ComparisonOp.lessThan => (Nat.blt (left) (right)))
  | FilterExpr.conjunction left right => (evaluateFilter (left) && evaluateFilter (right))
  | FilterExpr.negation inner => (!evaluateFilter (inner))

@[expose] public def filterNodeCount : (expression : FilterExpr) -> Nat
  | FilterExpr.literal _ => 1
  | FilterExpr.comparison _ _ _ => 1
  | FilterExpr.conjunction left right => (1 + (filterNodeCount (left) + filterNodeCount (right)))
  | FilterExpr.negation inner => (1 + filterNodeCount (inner))

@[expose] public def tcpPortFilter : FilterExpr := FilterExpr.conjunction (FilterExpr.comparison (ComparisonOp.equal) (443) (443)) (FilterExpr.negation (FilterExpr.comparison (ComparisonOp.greaterThan) (443) (1024)))

public theorem tcp_port_filter_evaluates_true : (evaluateFilter (tcpPortFilter) = true) := by
  rfl

public theorem tcp_port_filter_has_four_nodes : (filterNodeCount (tcpPortFilter) = 4) := by
  rfl

public theorem failed_equality_comparison_is_false : (evaluateFilter (FilterExpr.comparison (ComparisonOp.equal) (80) (443)) = false) := by
  rfl

end Tapwire.Tapwire.Filter
