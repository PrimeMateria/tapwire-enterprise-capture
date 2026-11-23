module
public import Init
public import Wireshark.Enterprise.AlertOperations
public import Wireshark.Enterprise.CapturePipeline
public import Wireshark.Enterprise.FileServerThreats
public import Wireshark.Enterprise.Invariants
public import Wireshark.Enterprise.Normalization
public import Wireshark.Wireshark.Capture
public import Wireshark.Wireshark.Dissector
public import Wireshark.Wireshark.Filter
public import Wireshark.Wireshark.Invariants
public import Wireshark.Wireshark.PcapNg
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Main

public theorem wireshark_model_integration_sound : ((Wireshark.Wireshark.Capture.isCaptureLimitsValid (Wireshark.Wireshark.Capture.defaultCaptureLimits) && (Wireshark.Wireshark.PcapNg.isValidBlock (Wireshark.Wireshark.PcapNg.alignedEnhancedPacketBlock) && (Wireshark.Wireshark.Dissector.isValidFieldInstance (Wireshark.Wireshark.Dissector.tcpPortField) && Wireshark.Wireshark.Filter.evaluateFilter (Wireshark.Wireshark.Filter.tcpPortFilter)))) = true) := by
  rfl

public theorem wireshark_rejects_malformed_block : (Wireshark.Wireshark.PcapNg.isValidBlock (Wireshark.Wireshark.PcapNg.misalignedEnhancedPacketBlock) = false) := by
  rfl

public theorem wireshark_section_magic_is_stable : ((Nat.beq (Wireshark.Wireshark.Capture.pcapngSectionMagic) (168627466)) = true) := by
  rfl

public theorem enterprise_capture_and_alert_integration_is_sound : (((Wireshark.Enterprise.CapturePipeline.isPipelineWellFormed (Wireshark.Enterprise.CapturePipeline.defaultEnterprisePipeline) && Wireshark.Enterprise.Normalization.isKnownFileActivityUid (Wireshark.Enterprise.Normalization.fileSystemActivityTypeUid (Wireshark.Enterprise.Normalization.fileRenamingActivityId))) && (Wireshark.Enterprise.FileServerThreats.matchesRemotePayloadRule (Wireshark.Enterprise.FileServerThreats.administrativePayloadEvent) && Wireshark.Enterprise.AlertOperations.shouldDispatchAlert (Wireshark.Enterprise.AlertOperations.highRiskOffHoursContext))) = true) := by
  rfl

public theorem enterprise_and_wireshark_models_are_jointly_consistent : (((Wireshark.Wireshark.Capture.isCaptureLimitsValid (Wireshark.Wireshark.Capture.defaultCaptureLimits) && Wireshark.Enterprise.CapturePipeline.hasDecoupledTransport (Wireshark.Enterprise.CapturePipeline.defaultEnterprisePipeline)) && (Wireshark.Enterprise.FileServerThreats.matchesRansomwareRule (Wireshark.Enterprise.FileServerThreats.ransomwareEvent) && (!Wireshark.Enterprise.AlertOperations.shouldDispatchAlert (Wireshark.Enterprise.AlertOperations.scannerContext)))) = true) := by
  rfl

end Wireshark.Main
