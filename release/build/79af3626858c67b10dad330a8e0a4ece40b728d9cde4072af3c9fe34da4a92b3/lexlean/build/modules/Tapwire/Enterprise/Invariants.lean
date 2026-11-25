module
public import Init
public import Tapwire.Enterprise.AlertOperations
public import Tapwire.Enterprise.CapturePipeline
public import Tapwire.Enterprise.FileServerThreats
public import Tapwire.Enterprise.Normalization
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Tapwire.Enterprise.Invariants

public theorem pipeline_and_normalization_are_coherent : ((Tapwire.Enterprise.CapturePipeline.isPipelineWellFormed (Tapwire.Enterprise.CapturePipeline.defaultEnterprisePipeline) && (Tapwire.Enterprise.Normalization.hasCanonicalNetworkEndpoints (Tapwire.Enterprise.Normalization.defaultEcsFileEvent) && Tapwire.Enterprise.Normalization.hasCanonicalFileFields (Tapwire.Enterprise.Normalization.defaultEcsFileEvent))) = true) := by
  rfl

public theorem normalization_and_detection_are_coherent : ((Tapwire.Enterprise.Normalization.isKnownFileActivityUid (Tapwire.Enterprise.Normalization.fileSystemActivityTypeUid (Tapwire.Enterprise.Normalization.fileRenamingActivityId)) && Tapwire.Enterprise.FileServerThreats.matchesRansomwareRule (Tapwire.Enterprise.FileServerThreats.ransomwareEvent)) = true) := by
  rfl

public theorem detection_and_alert_are_coherent : ((Tapwire.Enterprise.FileServerThreats.matchesRemotePayloadRule (Tapwire.Enterprise.FileServerThreats.administrativePayloadEvent) && Tapwire.Enterprise.AlertOperations.shouldDispatchAlert (Tapwire.Enterprise.AlertOperations.highRiskOffHoursContext)) = true) := by
  rfl

public theorem baseline_suppression_is_preserved : (((!Tapwire.Enterprise.AlertOperations.shouldDispatchAlert (Tapwire.Enterprise.AlertOperations.scannerContext)) && (!Tapwire.Enterprise.AlertOperations.shouldDispatchAlert (Tapwire.Enterprise.AlertOperations.businessHoursContext))) = true) := by
  rfl

public theorem critical_alert_selects_host_isolation : (Tapwire.Enterprise.AlertOperations.responseCode (Tapwire.Enterprise.AlertOperations.responseForLevel (Tapwire.Enterprise.AlertOperations.alertLevel (Tapwire.Enterprise.AlertOperations.highRiskOffHoursContext))) = 3) := by
  rfl

public theorem enterprise_integration_is_sound : (((Tapwire.Enterprise.CapturePipeline.isPipelineWellFormed (Tapwire.Enterprise.CapturePipeline.defaultEnterprisePipeline) && (Tapwire.Enterprise.Normalization.hasCanonicalNetworkEndpoints (Tapwire.Enterprise.Normalization.defaultOcsfRenameEvent) && Tapwire.Enterprise.Normalization.isKnownFileActivityUid ((Tapwire.Enterprise.Normalization.defaultOcsfRenameEvent).typeUid))) && ((Tapwire.Enterprise.FileServerThreats.matchesRemotePayloadRule (Tapwire.Enterprise.FileServerThreats.administrativePayloadEvent) && Tapwire.Enterprise.FileServerThreats.matchesShareEnumerationRule (Tapwire.Enterprise.FileServerThreats.shareFinderEvent)) && (Tapwire.Enterprise.FileServerThreats.matchesRansomwareRule (Tapwire.Enterprise.FileServerThreats.ransomwareEvent) && Tapwire.Enterprise.FileServerThreats.matchesExfiltrationRule (Tapwire.Enterprise.FileServerThreats.exfiltrationEvent)))) = true) := by
  rfl

end Tapwire.Enterprise.Invariants
