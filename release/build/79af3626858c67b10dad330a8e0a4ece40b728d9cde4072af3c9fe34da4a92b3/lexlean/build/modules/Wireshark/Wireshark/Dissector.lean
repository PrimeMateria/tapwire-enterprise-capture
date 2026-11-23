module
public import Init
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Wireshark.Dissector

public inductive ProtocolLayer where
  | ethernet
  | ipv4
  | tcp
  | udp
  | tls
  | http

public structure FieldInstance where
  index : Nat
  parentIndex : Nat
  fieldId : Nat
  depth : Nat
  layer : ProtocolLayer

@[expose] public def protocolLayerRank (layer : ProtocolLayer) : Nat := (match layer with | ProtocolLayer.ethernet => 1 | ProtocolLayer.ipv4 => 2 | ProtocolLayer.tcp => 3 | ProtocolLayer.udp => 3 | ProtocolLayer.tls => 4 | ProtocolLayer.http => 5)

@[expose] public def hasValidParentOrder (field : FieldInstance) : Bool := (Nat.blt ((field).parentIndex) ((field).index))

@[expose] public def isWithinDepthBudget (field : FieldInstance) : Bool := (Nat.ble ((field).depth) (32))

@[expose] public def isValidFieldInstance (field : FieldInstance) : Bool := (((Nat.blt (0) ((field).fieldId)) && hasValidParentOrder (field)) && isWithinDepthBudget (field))

@[expose] public def ipSourceField : FieldInstance := ({ index := 1, parentIndex := 0, fieldId := 11, depth := 1, layer := ProtocolLayer.ipv4 } : FieldInstance)

@[expose] public def tcpPortField : FieldInstance := ({ index := 2, parentIndex := 1, fieldId := 23, depth := 2, layer := ProtocolLayer.tcp } : FieldInstance)

public theorem ip_source_field_is_valid : (isValidFieldInstance (ipSourceField) = true) := by
  rfl

public theorem tcp_port_field_is_valid : (isValidFieldInstance (tcpPortField) = true) := by
  rfl

public theorem sampled_field_ids_are_distinct : ((Nat.beq ((ipSourceField).fieldId) ((tcpPortField).fieldId)) = false) := by
  rfl

public theorem sampled_protocol_layers_are_ordered : ((Nat.blt (protocolLayerRank ((ipSourceField).layer)) (protocolLayerRank ((tcpPortField).layer))) = true) := by
  rfl

end Wireshark.Wireshark.Dissector
