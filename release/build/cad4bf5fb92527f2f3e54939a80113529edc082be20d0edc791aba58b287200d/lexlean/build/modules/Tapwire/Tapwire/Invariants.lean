module
public import Init
public import Tapwire.Tapwire.Capture
public import Tapwire.Tapwire.Dissector
public import Tapwire.Tapwire.Filter
public import Tapwire.Tapwire.PcapNg
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Tapwire.Tapwire.Invariants

public theorem capture_limits_bound_packet_length : ((Nat.ble ((Tapwire.Tapwire.Capture.defaultCaptureLimits).maxPacketLength) ((Tapwire.Tapwire.Capture.defaultCaptureLimits).snaplen)) = true) := by
  rfl

public theorem pcapng_block_alignment_is_enforced : ((Tapwire.Tapwire.PcapNg.isAlignedTo32BitBoundary (Tapwire.Tapwire.PcapNg.alignedEnhancedPacketBlock) && (!Tapwire.Tapwire.PcapNg.isAlignedTo32BitBoundary (Tapwire.Tapwire.PcapNg.misalignedEnhancedPacketBlock))) = true) := by
  rfl

public theorem dissector_fields_respect_parent_and_depth : ((Tapwire.Tapwire.Dissector.isValidFieldInstance (Tapwire.Tapwire.Dissector.ipSourceField) && Tapwire.Tapwire.Dissector.isValidFieldInstance (Tapwire.Tapwire.Dissector.tcpPortField)) = true) := by
  rfl

public theorem display_filter_is_bounded : ((Nat.ble (Tapwire.Tapwire.Filter.filterNodeCount (Tapwire.Tapwire.Filter.tcpPortFilter)) (64)) = true) := by
  rfl

end Tapwire.Tapwire.Invariants
