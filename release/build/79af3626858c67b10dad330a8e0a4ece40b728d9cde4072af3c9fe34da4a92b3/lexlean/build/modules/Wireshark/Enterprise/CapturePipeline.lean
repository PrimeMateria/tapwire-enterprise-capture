module
public import Init
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Enterprise.CapturePipeline

public inductive MirrorEncapsulation where
  | physicalTap
  | spanPort
  | vxlanUdp
  | geneveUdp

public inductive PipelineTier where
  | trafficAcquisition
  | passiveSensorProcessing
  | decoupledTransportBuffering
  | ingestionStorage

public structure CapturePipeline where
  encapsulation : MirrorEncapsulation
  tunnelTerminated : Nat
  reusePortEnabled : Nat
  workerCount : Nat
  bufferedTransport : Nat
  topicCount : Nat

@[expose] public def tierIndex (tier : PipelineTier) : Nat := (match tier with | PipelineTier.trafficAcquisition => 0 | PipelineTier.passiveSensorProcessing => 1 | PipelineTier.decoupledTransportBuffering => 2 | PipelineTier.ingestionStorage => 3)

@[expose] public def isEncapsulationHandled (encapsulation : MirrorEncapsulation) (tunnelTerminated : Nat) : Bool := (match encapsulation with | MirrorEncapsulation.physicalTap => true | MirrorEncapsulation.spanPort => true | MirrorEncapsulation.vxlanUdp => (Nat.beq (tunnelTerminated) (1)) | MirrorEncapsulation.geneveUdp => (Nat.beq (tunnelTerminated) (1)))

@[expose] public def hasSensorLoadBalancing (pipeline : CapturePipeline) : Bool := ((Nat.beq ((pipeline).reusePortEnabled) (1)) && (Nat.ble (2) ((pipeline).workerCount)))

@[expose] public def hasDecoupledTransport (pipeline : CapturePipeline) : Bool := ((Nat.beq ((pipeline).bufferedTransport) (1)) && (Nat.blt (0) ((pipeline).topicCount)))

@[expose] public def isPipelineWellFormed (pipeline : CapturePipeline) : Bool := (isEncapsulationHandled ((pipeline).encapsulation) ((pipeline).tunnelTerminated) && (hasSensorLoadBalancing (pipeline) && hasDecoupledTransport (pipeline)))

@[expose] public def defaultEnterprisePipeline : CapturePipeline := ({ encapsulation := MirrorEncapsulation.geneveUdp, tunnelTerminated := 1, reusePortEnabled := 1, workerCount := 8, bufferedTransport := 1, topicCount := 3 } : CapturePipeline)

@[expose] public def unterminatedVxlanPipeline : CapturePipeline := ({ encapsulation := MirrorEncapsulation.vxlanUdp, tunnelTerminated := 0, reusePortEnabled := 1, workerCount := 8, bufferedTransport := 1, topicCount := 3 } : CapturePipeline)

public theorem default_pipeline_is_well_formed : (isPipelineWellFormed (defaultEnterprisePipeline) = true) := by
  rfl

public theorem unterminated_vxlan_pipeline_is_rejected : (isPipelineWellFormed (unterminatedVxlanPipeline) = false) := by
  rfl

public theorem pipeline_tiers_are_strictly_ordered : (((Nat.blt (tierIndex (PipelineTier.trafficAcquisition)) (tierIndex (PipelineTier.passiveSensorProcessing))) && ((Nat.blt (tierIndex (PipelineTier.passiveSensorProcessing)) (tierIndex (PipelineTier.decoupledTransportBuffering))) && (Nat.blt (tierIndex (PipelineTier.decoupledTransportBuffering)) (tierIndex (PipelineTier.ingestionStorage))))) = true) := by
  rfl

public theorem default_pipeline_buffers_sensor_output : (hasDecoupledTransport (defaultEnterprisePipeline) = true) := by
  rfl

end Wireshark.Enterprise.CapturePipeline
