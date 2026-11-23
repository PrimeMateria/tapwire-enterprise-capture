module
public import Init
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Wireshark.Capture

public structure CaptureLimits where
  snaplen : Nat
  linkType : Nat
  timestampPrecision : Nat
  maxPacketLength : Nat

@[expose] public def defaultCaptureLimits : CaptureLimits := ({ snaplen := 262144, linkType := 1, timestampPrecision := 6, maxPacketLength := 262144 } : CaptureLimits)

@[expose] public def classicPcapMagicMicroseconds : Nat := 2712847316

@[expose] public def classicPcapMagicNanoseconds : Nat := 2712847317

@[expose] public def pcapngSectionMagic : Nat := 168627466

@[expose] public def isSupportedLinkType (linkType : Nat) : Bool := ((Nat.ble (1) (linkType)) && (Nat.ble (linkType) (300)))

@[expose] public def isCaptureLimitsValid (limits : CaptureLimits) : Bool := (((Nat.blt (0) ((limits).snaplen)) && (Nat.ble ((limits).maxPacketLength) ((limits).snaplen))) && (((Nat.blt (0) ((limits).timestampPrecision)) && (Nat.ble ((limits).timestampPrecision) (9))) && isSupportedLinkType ((limits).linkType)))

public theorem default_capture_limits_are_valid : (isCaptureLimitsValid (defaultCaptureLimits) = true) := by
  rfl

public theorem pcap_magic_values_are_distinct : ((Nat.beq (classicPcapMagicMicroseconds) (classicPcapMagicNanoseconds)) = false) := by
  rfl

public theorem pcapng_section_magic_is_expected : ((Nat.beq (pcapngSectionMagic) (168627466)) = true) := by
  rfl

end Wireshark.Wireshark.Capture
