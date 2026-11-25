module
public import Init
public import Tapwire.Enterprise.AlertOperations
public import Tapwire.Enterprise.CapturePipeline
public import Tapwire.Enterprise.FileServerThreats
public import Tapwire.Enterprise.Invariants
public import Tapwire.Enterprise.Normalization
public import Tapwire.Tapwire.Capture
public import Tapwire.Tapwire.Dissector
public import Tapwire.Tapwire.Filter
public import Tapwire.Tapwire.Invariants
public import Tapwire.Tapwire.PcapNg
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Tapwire.Main

public theorem tapwire_model_integration_sound : ((Tapwire.Tapwire.Capture.isCaptureLimitsValid (Tapwire.Tapwire.Capture.defaultCaptureLimits) && (Tapwire.Tapwire.PcapNg.isValidBlock (Tapwire.Tapwire.PcapNg.alignedEnhancedPacketBlock) && (Tapwire.Tapwire.Dissector.isValidFieldInstance (Tapwire.Tapwire.Dissector.tcpPortField) && Tapwire.Tapwire.Filter.evaluateFilter (Tapwire.Tapwire.Filter.tcpPortFilter)))) = true) := by
  rfl

public theorem tapwire_rejects_malformed_block : (Tapwire.Tapwire.PcapNg.isValidBlock (Tapwire.Tapwire.PcapNg.misalignedEnhancedPacketBlock) = false) := by
  rfl

public theorem tapwire_section_magic_is_stable : ((Nat.beq (Tapwire.Tapwire.Capture.pcapngSectionMagic) (168627466)) = true) := by
  rfl

public theorem enterprise_capture_and_alert_integration_is_sound : (((Tapwire.Enterprise.CapturePipeline.isPipelineWellFormed (Tapwire.Enterprise.CapturePipeline.defaultEnterprisePipeline) && Tapwire.Enterprise.Normalization.isKnownFileActivityUid (Tapwire.Enterprise.Normalization.fileSystemActivityTypeUid (Tapwire.Enterprise.Normalization.fileRenamingActivityId))) && (Tapwire.Enterprise.FileServerThreats.matchesRemotePayloadRule (Tapwire.Enterprise.FileServerThreats.administrativePayloadEvent) && Tapwire.Enterprise.AlertOperations.shouldDispatchAlert (Tapwire.Enterprise.AlertOperations.highRiskOffHoursContext))) = true) := by
  rfl

public theorem enterprise_and_tapwire_models_are_jointly_consistent : (((Tapwire.Tapwire.Capture.isCaptureLimitsValid (Tapwire.Tapwire.Capture.defaultCaptureLimits) && Tapwire.Enterprise.CapturePipeline.hasDecoupledTransport (Tapwire.Enterprise.CapturePipeline.defaultEnterprisePipeline)) && (Tapwire.Enterprise.FileServerThreats.matchesRansomwareRule (Tapwire.Enterprise.FileServerThreats.ransomwareEvent) && (!Tapwire.Enterprise.AlertOperations.shouldDispatchAlert (Tapwire.Enterprise.AlertOperations.scannerContext)))) = true) := by
  rfl

end Tapwire.Main
