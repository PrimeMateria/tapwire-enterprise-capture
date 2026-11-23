module
public import Init
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Enterprise.AlertOperations

public inductive AlertLevel where
  | informational
  | medium
  | high
  | critical

public inductive ResponseAction where
  | flagForHunting
  | revokeSession
  | isolateHost
  | killEncryptingProcess
  | blockEgress

public inductive BaselineClass where
  | vulnerabilityScanner
  | backupAgent
  | managementSubnet
  | untrustedWifi

public structure AlertContext where
  baseline : BaselineClass
  suppressed : Nat
  offHours : Nat
  untrustedSegment : Nat
  baseScore : Nat
  threshold : Nat
  networkCorrelated : Nat
  endpointCorrelated : Nat

@[expose] public def isSuppressed (context : AlertContext) : Bool := (Nat.beq ((context).suppressed) (1))

@[expose] public def baselineWeight (baseline : BaselineClass) : Nat := (match baseline with | BaselineClass.vulnerabilityScanner => 0 | BaselineClass.backupAgent => 0 | BaselineClass.managementSubnet => 10 | BaselineClass.untrustedWifi => 30)

@[expose] public def contextualScore (context : AlertContext) : Nat := (((context).baseScore + (if (Nat.beq ((context).offHours) (1)) then 30 else 0)) + ((if (Nat.beq ((context).untrustedSegment) (1)) then 20 else 0) + baselineWeight ((context).baseline)))

@[expose] public def hasEndpointCorrelation (context : AlertContext) : Bool := (Nat.beq ((context).endpointCorrelated) (1))

@[expose] public def shouldDispatchAlert (context : AlertContext) : Bool := ((((!isSuppressed (context)) && (Nat.ble ((context).threshold) (contextualScore (context)))) && (Nat.beq ((context).networkCorrelated) (1))) && hasEndpointCorrelation (context))

@[expose] public def alertLevelForScore (score : Nat) : AlertLevel := (if (Nat.ble (80) (score)) then AlertLevel.critical else (if (Nat.ble (60) (score)) then AlertLevel.high else (if (Nat.ble (30) (score)) then AlertLevel.medium else AlertLevel.informational)))

@[expose] public def alertLevel (context : AlertContext) : AlertLevel := alertLevelForScore (contextualScore (context))

@[expose] public def responseForLevel (level : AlertLevel) : ResponseAction := (match level with | AlertLevel.informational => ResponseAction.flagForHunting | AlertLevel.medium => ResponseAction.flagForHunting | AlertLevel.high => ResponseAction.revokeSession | AlertLevel.critical => ResponseAction.isolateHost)

@[expose] public def responseCode (action : ResponseAction) : Nat := (match action with | ResponseAction.flagForHunting => 1 | ResponseAction.revokeSession => 2 | ResponseAction.isolateHost => 3 | ResponseAction.killEncryptingProcess => 4 | ResponseAction.blockEgress => 5)

@[expose] public def areResponseCodesDistinct : Bool := ((!(Nat.beq (responseCode (ResponseAction.isolateHost)) (responseCode (ResponseAction.killEncryptingProcess)))) && (!(Nat.beq (responseCode (ResponseAction.blockEgress)) (responseCode (ResponseAction.flagForHunting)))))

@[expose] public def highRiskOffHoursContext : AlertContext := ({ baseline := BaselineClass.untrustedWifi, suppressed := 0, offHours := 1, untrustedSegment := 1, baseScore := 30, threshold := 60, networkCorrelated := 1, endpointCorrelated := 1 } : AlertContext)

@[expose] public def scannerContext : AlertContext := ({ baseline := BaselineClass.vulnerabilityScanner, suppressed := 1, offHours := 0, untrustedSegment := 0, baseScore := 90, threshold := 60, networkCorrelated := 1, endpointCorrelated := 1 } : AlertContext)

@[expose] public def businessHoursContext : AlertContext := ({ baseline := BaselineClass.managementSubnet, suppressed := 0, offHours := 0, untrustedSegment := 0, baseScore := 40, threshold := 60, networkCorrelated := 1, endpointCorrelated := 1 } : AlertContext)

public theorem high_risk_context_dispatches_alert : (shouldDispatchAlert (highRiskOffHoursContext) = true) := by
  rfl

public theorem high_risk_context_is_critical : (alertLevel (highRiskOffHoursContext) = AlertLevel.critical) := by
  rfl

public theorem scanner_baseline_suppresses_alert : (shouldDispatchAlert (scannerContext) = false) := by
  rfl

public theorem business_hours_context_stays_below_threshold : (shouldDispatchAlert (businessHoursContext) = false) := by
  rfl

public theorem high_risk_response_is_host_isolation : (responseCode (responseForLevel (alertLevel (highRiskOffHoursContext))) = 3) := by
  rfl

public theorem response_codes_are_distinct : (areResponseCodesDistinct = true) := by
  rfl

end Wireshark.Enterprise.AlertOperations
