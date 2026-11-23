module
public import Init
public import LexLeanRuntime.Portable
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Wireshark.Enterprise.Normalization

public inductive TelemetrySchema where
  | nativeZeek
  | ecs
  | ocsf
  | udm

public inductive ZeekLogSource where
  | connLog
  | smbMappingLog
  | smbFilesLog
  | suricataAlert

public structure NormalizedEvent where
  sourceLog : ZeekLogSource
  schema : TelemetrySchema
  sourceIpField : Nat
  destinationIpField : Nat
  fileNameField : Nat
  filePathField : Nat
  typeUid : Nat

@[expose] public def fileSystemClassUid : Nat := 1001

@[expose] public def networkActivityClassUid : Nat := 4001

@[expose] public def fileCreationActivityId : Nat := 1

@[expose] public def fileRenamingActivityId : Nat := 5

@[expose] public def fileSystemActivityTypeUid (activityId : Nat) : Nat := ((LexLeanRuntime.multiply (fileSystemClassUid) (100) : Nat) + activityId)

@[expose] public def sourceIpFieldCode (schema : TelemetrySchema) : Nat := (match schema with | TelemetrySchema.nativeZeek => 31 | TelemetrySchema.ecs => 1 | TelemetrySchema.ocsf => 11 | TelemetrySchema.udm => 21)

@[expose] public def destinationIpFieldCode (schema : TelemetrySchema) : Nat := (match schema with | TelemetrySchema.nativeZeek => 32 | TelemetrySchema.ecs => 2 | TelemetrySchema.ocsf => 12 | TelemetrySchema.udm => 22)

@[expose] public def fileNameFieldCode (schema : TelemetrySchema) : Nat := (match schema with | TelemetrySchema.nativeZeek => 33 | TelemetrySchema.ecs => 3 | TelemetrySchema.ocsf => 13 | TelemetrySchema.udm => 23)

@[expose] public def filePathFieldCode (schema : TelemetrySchema) : Nat := (match schema with | TelemetrySchema.nativeZeek => 34 | TelemetrySchema.ecs => 4 | TelemetrySchema.ocsf => 14 | TelemetrySchema.udm => 24)

@[expose] public def hasCanonicalNetworkEndpoints (event : NormalizedEvent) : Bool := ((Nat.beq ((event).sourceIpField) (sourceIpFieldCode ((event).schema))) && (Nat.beq ((event).destinationIpField) (destinationIpFieldCode ((event).schema))))

@[expose] public def hasCanonicalFileFields (event : NormalizedEvent) : Bool := ((Nat.beq ((event).fileNameField) (fileNameFieldCode ((event).schema))) && (Nat.beq ((event).filePathField) (filePathFieldCode ((event).schema))))

@[expose] public def isFileCreationUid (typeUid : Nat) : Bool := (Nat.beq (typeUid) (fileSystemActivityTypeUid (fileCreationActivityId)))

@[expose] public def isFileRenamingUid (typeUid : Nat) : Bool := (Nat.beq (typeUid) (fileSystemActivityTypeUid (fileRenamingActivityId)))

@[expose] public def isKnownFileActivityUid (typeUid : Nat) : Bool := (isFileCreationUid (typeUid) || isFileRenamingUid (typeUid))

@[expose] public def areFileActivityUidsDistinctAndKnown : Bool := ((!(Nat.beq (fileSystemActivityTypeUid (fileCreationActivityId)) (fileSystemActivityTypeUid (fileRenamingActivityId)))) && isKnownFileActivityUid (fileSystemActivityTypeUid (fileRenamingActivityId)))

@[expose] public def defaultEcsFileEvent : NormalizedEvent := ({ sourceLog := ZeekLogSource.smbFilesLog, schema := TelemetrySchema.ecs, sourceIpField := 1, destinationIpField := 2, fileNameField := 3, filePathField := 4, typeUid := 0 } : NormalizedEvent)

@[expose] public def defaultOcsfRenameEvent : NormalizedEvent := ({ sourceLog := ZeekLogSource.smbFilesLog, schema := TelemetrySchema.ocsf, sourceIpField := 11, destinationIpField := 12, fileNameField := 13, filePathField := 14, typeUid := 100105 } : NormalizedEvent)

public theorem file_creation_uid_matches_specification : ((Nat.beq (fileSystemActivityTypeUid (fileCreationActivityId)) (100101)) = true) := by
  rfl

public theorem file_renaming_uid_matches_specification : ((Nat.beq (fileSystemActivityTypeUid (fileRenamingActivityId)) (100105)) = true) := by
  rfl

public theorem file_activity_uids_are_distinct : (areFileActivityUidsDistinctAndKnown = true) := by
  rfl

public theorem ecs_event_has_canonical_fields : ((hasCanonicalNetworkEndpoints (defaultEcsFileEvent) && hasCanonicalFileFields (defaultEcsFileEvent)) = true) := by
  rfl

public theorem ocsf_rename_event_is_known_file_activity : (((hasCanonicalNetworkEndpoints (defaultOcsfRenameEvent) && hasCanonicalFileFields (defaultOcsfRenameEvent)) && isKnownFileActivityUid ((defaultOcsfRenameEvent).typeUid)) = true) := by
  rfl

end Wireshark.Enterprise.Normalization
