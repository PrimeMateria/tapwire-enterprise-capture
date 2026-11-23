module
public import Init
public import Wireshark.Enterprise.AlertOperations
public import Wireshark.Enterprise.CapturePipeline
public import Wireshark.Enterprise.FileServerThreats
public import Wireshark.Enterprise.Normalization
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Enterprise.Invariants

public theorem pipeline_and_normalization_are_coherent : ((Wireshark.Enterprise.CapturePipeline.isPipelineWellFormed (Wireshark.Enterprise.CapturePipeline.defaultEnterprisePipeline) && (Wireshark.Enterprise.Normalization.hasCanonicalNetworkEndpoints (Wireshark.Enterprise.Normalization.defaultEcsFileEvent) && Wireshark.Enterprise.Normalization.hasCanonicalFileFields (Wireshark.Enterprise.Normalization.defaultEcsFileEvent))) = true) := by
  rfl

public theorem normalization_and_detection_are_coherent : ((Wireshark.Enterprise.Normalization.isKnownFileActivityUid (Wireshark.Enterprise.Normalization.fileSystemActivityTypeUid (Wireshark.Enterprise.Normalization.fileRenamingActivityId)) && Wireshark.Enterprise.FileServerThreats.matchesRansomwareRule (Wireshark.Enterprise.FileServerThreats.ransomwareEvent)) = true) := by
  rfl

public theorem detection_and_alert_are_coherent : ((Wireshark.Enterprise.FileServerThreats.matchesRemotePayloadRule (Wireshark.Enterprise.FileServerThreats.administrativePayloadEvent) && Wireshark.Enterprise.AlertOperations.shouldDispatchAlert (Wireshark.Enterprise.AlertOperations.highRiskOffHoursContext)) = true) := by
  rfl

public theorem baseline_suppression_is_preserved : (((!Wireshark.Enterprise.AlertOperations.shouldDispatchAlert (Wireshark.Enterprise.AlertOperations.scannerContext)) && (!Wireshark.Enterprise.AlertOperations.shouldDispatchAlert (Wireshark.Enterprise.AlertOperations.businessHoursContext))) = true) := by
  rfl

public theorem critical_alert_selects_host_isolation : (Wireshark.Enterprise.AlertOperations.responseCode (Wireshark.Enterprise.AlertOperations.responseForLevel (Wireshark.Enterprise.AlertOperations.alertLevel (Wireshark.Enterprise.AlertOperations.highRiskOffHoursContext))) = 3) := by
  rfl

public theorem enterprise_integration_is_sound : (((Wireshark.Enterprise.CapturePipeline.isPipelineWellFormed (Wireshark.Enterprise.CapturePipeline.defaultEnterprisePipeline) && (Wireshark.Enterprise.Normalization.hasCanonicalNetworkEndpoints (Wireshark.Enterprise.Normalization.defaultOcsfRenameEvent) && Wireshark.Enterprise.Normalization.isKnownFileActivityUid ((Wireshark.Enterprise.Normalization.defaultOcsfRenameEvent).typeUid))) && ((Wireshark.Enterprise.FileServerThreats.matchesRemotePayloadRule (Wireshark.Enterprise.FileServerThreats.administrativePayloadEvent) && Wireshark.Enterprise.FileServerThreats.matchesShareEnumerationRule (Wireshark.Enterprise.FileServerThreats.shareFinderEvent)) && (Wireshark.Enterprise.FileServerThreats.matchesRansomwareRule (Wireshark.Enterprise.FileServerThreats.ransomwareEvent) && Wireshark.Enterprise.FileServerThreats.matchesExfiltrationRule (Wireshark.Enterprise.FileServerThreats.exfiltrationEvent)))) = true) := by
  rfl

end Wireshark.Enterprise.Invariants
