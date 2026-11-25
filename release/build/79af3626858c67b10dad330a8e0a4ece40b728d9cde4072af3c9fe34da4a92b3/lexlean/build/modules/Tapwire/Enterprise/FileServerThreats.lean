module
public import Init
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace Tapwire.Enterprise.FileServerThreats

public inductive AttackPhase where
  | reconnaissance
  | lateralMovement
  | destructionEncryption
  | exfiltration

public inductive ShareKind where
  | ipcShare
  | cShare
  | adminShare
  | sysvolShare
  | customShare

public inductive FileAction where
  | fileCreate
  | fileWrite
  | fileOpen
  | fileRename
  | fileRead

public inductive ExtensionKind where
  | executableExtension
  | ransomwareExtension
  | benignExtension

public structure FileShareEvent where
  share : ShareKind
  action : FileAction
  extension : ExtensionKind
  distinctTargets : Nat
  eventCount : Nat
  windowSeconds : Nat

@[expose] public def isAdministrativeShare (share : ShareKind) : Bool := (match share with | ShareKind.cShare => true | ShareKind.adminShare => true | ShareKind.ipcShare => false | ShareKind.sysvolShare => false | ShareKind.customShare => false)

@[expose] public def isDefaultShare (share : ShareKind) : Bool := (match share with | ShareKind.ipcShare => true | ShareKind.cShare => true | ShareKind.adminShare => true | ShareKind.sysvolShare => false | ShareKind.customShare => false)

@[expose] public def isPayloadAction (action : FileAction) : Bool := (match action with | FileAction.fileCreate => true | FileAction.fileWrite => true | FileAction.fileOpen => true | FileAction.fileRename => false | FileAction.fileRead => false)

@[expose] public def isRenameAction (action : FileAction) : Bool := (match action with | FileAction.fileCreate => false | FileAction.fileWrite => false | FileAction.fileOpen => false | FileAction.fileRename => true | FileAction.fileRead => false)

@[expose] public def isReadAction (action : FileAction) : Bool := (match action with | FileAction.fileCreate => false | FileAction.fileWrite => false | FileAction.fileOpen => false | FileAction.fileRename => false | FileAction.fileRead => true)

@[expose] public def isExecutableExtension (extension : ExtensionKind) : Bool := (match extension with | ExtensionKind.executableExtension => true | ExtensionKind.ransomwareExtension => false | ExtensionKind.benignExtension => false)

@[expose] public def isRansomwareExtension (extension : ExtensionKind) : Bool := (match extension with | ExtensionKind.executableExtension => false | ExtensionKind.ransomwareExtension => true | ExtensionKind.benignExtension => false)

@[expose] public def matchesRemotePayloadRule (event : FileShareEvent) : Bool := (isAdministrativeShare ((event).share) && (isPayloadAction ((event).action) && isExecutableExtension ((event).extension)))

@[expose] public def matchesShareEnumerationRule (event : FileShareEvent) : Bool := (isDefaultShare ((event).share) && ((Nat.ble (15) ((event).distinctTargets)) && (Nat.ble ((event).windowSeconds) (10))))

@[expose] public def matchesRansomwareRule (event : FileShareEvent) : Bool := (((isRenameAction ((event).action) || isRansomwareExtension ((event).extension)) && (Nat.ble (50) ((event).eventCount))) && (Nat.ble ((event).windowSeconds) (60)))

@[expose] public def matchesExfiltrationRule (event : FileShareEvent) : Bool := ((isReadAction ((event).action) && (Nat.ble (500) ((event).eventCount))) && (Nat.ble ((event).windowSeconds) (300)))

@[expose] public def phaseCode (phase : AttackPhase) : Nat := (match phase with | AttackPhase.reconnaissance => 1135 | AttackPhase.lateralMovement => 1021 | AttackPhase.destructionEncryption => 1486 | AttackPhase.exfiltration => 1567)

@[expose] public def areThreatPhaseCodesDistinct : Bool := ((!(Nat.beq (phaseCode (AttackPhase.reconnaissance)) (phaseCode (AttackPhase.lateralMovement)))) && (!(Nat.beq (phaseCode (AttackPhase.destructionEncryption)) (phaseCode (AttackPhase.exfiltration)))))

@[expose] public def administrativePayloadEvent : FileShareEvent := ({ share := ShareKind.cShare, action := FileAction.fileCreate, extension := ExtensionKind.executableExtension, distinctTargets := 1, eventCount := 1, windowSeconds := 60 } : FileShareEvent)

@[expose] public def shareFinderEvent : FileShareEvent := ({ share := ShareKind.ipcShare, action := FileAction.fileOpen, extension := ExtensionKind.benignExtension, distinctTargets := 18, eventCount := 18, windowSeconds := 10 } : FileShareEvent)

@[expose] public def ransomwareEvent : FileShareEvent := ({ share := ShareKind.customShare, action := FileAction.fileRename, extension := ExtensionKind.ransomwareExtension, distinctTargets := 1, eventCount := 50, windowSeconds := 60 } : FileShareEvent)

@[expose] public def exfiltrationEvent : FileShareEvent := ({ share := ShareKind.customShare, action := FileAction.fileRead, extension := ExtensionKind.benignExtension, distinctTargets := 1, eventCount := 500, windowSeconds := 300 } : FileShareEvent)

@[expose] public def benignReadEvent : FileShareEvent := ({ share := ShareKind.customShare, action := FileAction.fileRead, extension := ExtensionKind.benignExtension, distinctTargets := 1, eventCount := 10, windowSeconds := 300 } : FileShareEvent)

public theorem administrative_payload_event_is_detected : (matchesRemotePayloadRule (administrativePayloadEvent) = true) := by
  rfl

public theorem share_finder_pattern_is_detected : (matchesShareEnumerationRule (shareFinderEvent) = true) := by
  rfl

public theorem ransomware_pattern_is_detected : (matchesRansomwareRule (ransomwareEvent) = true) := by
  rfl

public theorem exfiltration_pattern_is_detected : (matchesExfiltrationRule (exfiltrationEvent) = true) := by
  rfl

public theorem benign_read_is_not_exfiltration : (matchesExfiltrationRule (benignReadEvent) = false) := by
  rfl

public theorem threat_phase_codes_are_distinct : (areThreatPhaseCodesDistinct = true) := by
  rfl

end Tapwire.Enterprise.FileServerThreats
