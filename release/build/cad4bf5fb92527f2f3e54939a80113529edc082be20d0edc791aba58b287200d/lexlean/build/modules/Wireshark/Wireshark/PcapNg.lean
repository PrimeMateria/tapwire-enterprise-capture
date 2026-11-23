module
public import Init
public import LexLeanRuntime.Portable
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Wireshark.PcapNg

public inductive BlockKind where
  | sectionHeader
  | interfaceDescription
  | enhancedPacket
  | nameResolution
  | interfaceStatistics

public structure Block where
  index : Nat
  kind : BlockKind
  totalLength : Nat
  bodyLength : Nat

@[expose] public def wellFormedBlockLengths (block : Block) : Bool := ((Nat.ble (12) ((block).totalLength)) && ((Nat.ble ((block).bodyLength) ((block).totalLength)) && (Nat.ble ((block).bodyLength) (262144))))

@[expose] public def isAlignedTo32BitBoundary (block : Block) : Bool := (Nat.beq ((LexLeanRuntime.remainder ((block).totalLength) (4) (0) : Nat)) (0))

@[expose] public def isValidBlock (block : Block) : Bool := (wellFormedBlockLengths (block) && isAlignedTo32BitBoundary (block))

@[expose] public def alignedEnhancedPacketBlock : Block := ({ index := 0, kind := BlockKind.enhancedPacket, totalLength := 96, bodyLength := 84 } : Block)

@[expose] public def misalignedEnhancedPacketBlock : Block := ({ index := 1, kind := BlockKind.enhancedPacket, totalLength := 97, bodyLength := 84 } : Block)

public theorem aligned_packet_block_is_valid : (isValidBlock (alignedEnhancedPacketBlock) = true) := by
  rfl

public theorem misaligned_packet_block_is_rejected : (isValidBlock (misalignedEnhancedPacketBlock) = false) := by
  rfl

end Wireshark.Wireshark.PcapNg
