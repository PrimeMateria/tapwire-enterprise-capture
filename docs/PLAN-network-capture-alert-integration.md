# Integration Plan — Network Capture and Alert Planning

**Project:** `/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production`  
**Source document:** `Network Capture and Alert Planning.txt`  
**Governing ADR:** `docs/adr/adr-0001-network-capture-alert-integration.tex`  
**Date:** 2026-11-23  
**Status:** Planned → executed with this change set

## 1. Objective

Integrate the modelable requirements of `Network Capture and Alert Planning.txt` into the existing
LexLean 1.2 Wireshark rewrite as **new formal modules**, not as a copied document and not as an
operational deployment. The result remains a bounded, kernel-verified model in the style of
`kuramoto-prism` and `o3de-prism`.

## 2. Scope boundaries

The source document describes real infrastructure (TAP/SPAN, AWS VXLAN, GCP GENEVE, Zeek, Suricata,
Kafka, OpenTelemetry/Fluent Bit/Logstash, Elasticsearch/OpenSearch, ECS/OCSF/UDM, SIEM and SOAR).
This integration models only the finite structural and decision properties needed to reason about
that architecture:

- tier ordering and decoupling properties;
- normalization identifiers and field-role mappings;
- the four threat/rule families and their numeric thresholds;
- baseline suppression, contextual scoring and alert severity;
- network/endpoint correlation and response selection.

It does **not** claim to deploy, parse, or reproduce those external systems.

## 3. Requirements-to-model traceability

| Source area | Modeled claim | Target module |
| --- | --- | --- |
| Four-tier capture architecture; TAP/SPAN/VXLAN/GENEVE; `SO_REUSEPORT`; Kafka buffering | Tier order, encapsulation termination, worker balancing, buffered transport | `src/Enterprise/CapturePipeline.lex.tex` |
| ECS/OCSF/UDM normalization; `type_uid = class_uid * 100 + activity_id`; source/destination/file field mappings | Schema identifiers, canonical field roles, File System Activity UID computation | `src/Enterprise/Normalization.lex.tex` |
| Threat lifecycle T1135/T1021.002/T1486/T1567 and Rules 1–4 | Share/action/extension predicates and thresholded correlation patterns | `src/Enterprise/FileServerThreats.lex.tex` |
| Baseline filtering, contextual scoring, SIEM dispatch, triage/correlation table, SOAR playbooks | Exclusion, score threshold, alert level, endpoint correlation, response action | `src/Enterprise/AlertOperations.lex.tex` |
| Cross-cutting consistency | Pipeline → normalization → detection → alert consistency | `src/Enterprise/Invariants.lex.tex` |
| Existing Wireshark model | Top-level integration with pre-existing pcapng/dissector/filter suite | `src/Main.lex.tex` |

## 4. Implementation phases

### Phase 1 — Governance artifacts
1. Create this plan.
2. Create the `.tex` ADR recording context, decision, drivers, traceability, consequences and
   verification evidence.

### Phase 2 — Closed-lexicon additions
1. Add title entries under `language/wireshark.titles/entries/` for every new module.
2. Keep entry IDs equal to their file basenames, as required by LexLean lexicon validation.

### Phase 3 — LexLean modules
1. `Enterprise.CapturePipeline`: finite encodings of mirroring, tier order, load balancing and
   buffering.
2. `Enterprise.Normalization`: finite encodings of schema field roles and OCSF `type_uid`.
3. `Enterprise.FileServerThreats`: administrative-share payload, share enumeration, ransomware
   rename, and mass-read predicates with exact documented thresholds.
4. `Enterprise.AlertOperations`: baseline suppression, contextual scoring, alert level and SOAR
   response.
5. `Enterprise.Invariants`: cross-module consistency theorems.
6. Extend `Main` with top-level integration theorems.

### Phase 4 — Project configuration
1. Add all new modules to the sorted canonical `entrypoints` array in `lexlean.toml`.
2. Run `lexlean fmt --all`, then `lexlean lock`.

### Phase 5 — Verification and release
1. `lexlean fmt --all --check`
2. `lexlean lock --check`
3. `lexlean check --all`
4. `lexlean verify --all`
5. `lake build --allow-empty`
6. `prismpm check`
7. `prismpm build`
8. Record the resulting semantic ID, Lean attestation and PrismPM release hash in `README.md` and
   the ADR.

## 5. Acceptance criteria

- Every source module is canonical under `lexlean fmt --all --check`.
- `lexlean.lock` is current.
- `lexlean check --all` and `lexlean verify --all` pass with no sorries or dynamic axioms.
- `prismpm check` and `prismpm build` publish a new release.
- Existing Wireshark modules and the original `../wireshark` tree remain intact.
- `README.md` and the ADR accurately state the new scope and hashes.

## 6. Non-goals

- No line-by-line port of Zeek, Suricata, Kafka, Elasticsearch, OpenSearch, SIEM or SOAR code.
- No network installation or runtime deployment.
- No claim of equivalence between the formal model and any production security stack.
