module
public import Init
public import Wireshark.Wireshark.Capture
public import Wireshark.Wireshark.Dissector
public import Wireshark.Wireshark.Filter
public import Wireshark.Wireshark.PcapNg
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Wireshark.Invariants

public theorem capture_limits_bound_packet_length : ((Nat.ble ((Wireshark.Wireshark.Capture.defaultCaptureLimits).maxPacketLength) ((Wireshark.Wireshark.Capture.defaultCaptureLimits).snaplen)) = true) := by
  rfl

public theorem pcapng_block_alignment_is_enforced : ((Wireshark.Wireshark.PcapNg.isAlignedTo32BitBoundary (Wireshark.Wireshark.PcapNg.alignedEnhancedPacketBlock) && (!Wireshark.Wireshark.PcapNg.isAlignedTo32BitBoundary (Wireshark.Wireshark.PcapNg.misalignedEnhancedPacketBlock))) = true) := by
  rfl

public theorem dissector_fields_respect_parent_and_depth : ((Wireshark.Wireshark.Dissector.isValidFieldInstance (Wireshark.Wireshark.Dissector.ipSourceField) && Wireshark.Wireshark.Dissector.isValidFieldInstance (Wireshark.Wireshark.Dissector.tcpPortField)) = true) := by
  rfl

public theorem display_filter_is_bounded : ((Nat.ble (Wireshark.Wireshark.Filter.filterNodeCount (Wireshark.Wireshark.Filter.tcpPortFilter)) (64)) = true) := by
  rfl

end Wireshark.Wireshark.Invariants
