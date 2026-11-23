# Wireshark — LexLean formal rewrite

This directory is the **LexLean 1.2 rewrite** of the Wireshark subsystem, created next to the
original source tree at `../wireshark`. It is **not** a copy of the 495 MB C/C++ tree and **not** a
proof of the complete Wireshark binary. It is a closed-lexicon, kernel-verified formal model of a
bounded set of Wireshark/pcapng/dissector/display-filter claims, following the same pattern as
`../kuramoto-prism` and `../o3de-prism`.

The project also integrates the modelable requirements of
`Network Capture and Alert Planning.txt` as five additional enterprise capture/alert modules. The
governance artifacts are:

- `docs/PLAN-network-capture-alert-integration.md`
- `docs/adr/adr-0001-network-capture-alert-integration.tex`

## What is modeled

| Module | Scope |
| --- | --- |
| `src/Wireshark/Capture.lex.tex` | Capture limits (snaplen, link type, timestamp precision), pcap/pcapng magic values, capture-limit validity. |
| `src/Wireshark/PcapNg.lex.tex` | pcapng block kinds, block-length bounds, 32-bit alignment, acceptance/rejection of sample blocks. |
| `src/Wireshark/Dissector.lex.tex` | Protocol layers, dissector field instances, parent ordering, depth budget, distinct field IDs. |
| `src/Wireshark/Filter.lex.tex` | Display-filter expression tree, recursive evaluator, node count, concrete evaluation results. |
| `src/Wireshark/Invariants.lex.tex` | Cross-module invariants tying capture, block, dissector and filter models together. |
| `src/Enterprise/CapturePipeline.lex.tex` | Four-tier enterprise capture architecture, TAP/SPAN/VXLAN/GENEVE encodings, tunnel termination, load balancing and Kafka-style buffering. |
| `src/Enterprise/Normalization.lex.tex` | ECS/OCSF/UDM field roles, OCSF class/activity codes and the `type_uid = class_uid * 100 + activity_id` formula. |
| `src/Enterprise/FileServerThreats.lex.tex` | Administrative-share payload, share enumeration, ransomware rename and mass-read detection rules with documented thresholds. |
| `src/Enterprise/AlertOperations.lex.tex` | Baseline suppression, contextual scoring, alert severity, endpoint correlation and SOAR response codes. |
| `src/Enterprise/Invariants.lex.tex` | Cross-module enterprise invariants and the joint enterprise integration theorem. |
| `src/Main.lex.tex` | Top-level integration and rejection theorems for both Wireshark and enterprise models. |
| `src/Foundation/{Arch,Qual,Sec}.lex.tex` | PRISM architecture/quality/security facets reused from the established rewrite pattern. |

The model contains 14 verified modules, 52 theorems, 99 definitions, 24 inductive types and 39
structures. Every theorem is discharged by the Lean 4 kernel with no sorries and no dynamic
tactic axioms.

## Layout

```text
production/
├── lexlean.toml / lexlean.lock       canonical LexLean project + lock
├── prismpm.toml / prismpm.lock       PrismPM release configuration + lock
├── language/                         closed lexicons (wireshark.titles + prism.*)
├── src/                              14 canonical .lex.tex modules
├── docs/                             integration plan and .tex ADR
├── production/request.json           LexLean production export request
├── release/build/<hash>/             PrismPM immutable release
├── .lexlean/production/<hash>/       exported certified Rust bundle + evidence
├── .lexlean/build/                   content-addressed Lean/IR build outputs
├── run_tests.py                     authoritative 9-suite test runner + report generator
├── run-tests.sh                     shell runner wrapper with PATH normalization
├── tools.lock                       pinned toolchain versions + SHA-256 digests
├── scripts/install-tools.sh         cryptographic tool bootstrap for CI
├── reports/                         automated verification reports
│   ├── TEST_REPORT_LATEST.md        stable human-readable latest report (committed)
│   ├── test_report_latest.json      stable machine-readable latest report (committed)
│   └── logs/                        raw suite execution logs (git-ignored)
├── .githooks/pre-commit             local pre-commit verification gate
├── install-hooks.sh                 git initializer + pre-commit hook installer
├── .github/workflows/verify-test.yml automated GitHub Actions verification workflow
└── verify.sh                        thin delegate to ./run-tests.sh --quiet
```

## Verification & Test Harness

### Full 9-Suite Automated Verification

Execute the authoritative test runner:

```bash
./run-tests.sh
```

Or invoke Python directly:

```bash
python3 run_tests.py
```

Runner options:
- `./run-tests.sh --ci`: Strict UTC timestamps, no ANSI color escapes, fail-closed CI execution.
- `./run-tests.sh --hook`: Git pre-commit hook mode (halts commit on failure, auto-stages latest reports on pass).
- `./run-tests.sh --quiet`: Quiet execution for scripting; delegates from `verify.sh`.

### Local Developer Pre-Commit Hook

Install the pre-commit gate:

```bash
./install-hooks.sh
```

Every `git commit` executes `./run-tests.sh --hook`, validates all 9 verification suites (including Lean 4 kernel formal attestation and PrismPM model compilation), and automatically stages the synchronized latest reports upon passing.

### Generated Reports & Audit Ledgers

Every test run automatically produces paired reports under `reports/`:
- **Human-Readable Markdown**: [`reports/TEST_REPORT_LATEST.md`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/reports/TEST_REPORT_LATEST.md)
- **Machine-Readable JSON**: [`reports/test_report_latest.json`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/reports/test_report_latest.json)

## Recorded Results & Attestation Baseline

- Semantic IR ID: `82a79bd033b89dc60f05bd8f58518b2f5d77d6e10c7b839ae02296ab422611b2`
- Lean Attestation: `d633598a6e4acdde2a11a1ddc39e35eaeb3d8a2d6d61510c5508b266671b2460`
- PrismPM Release: `79af3626858c67b10dad330a8e0a4ece40b728d9cde4072af3c9fe34da4a92b3`
- LexLean Production Export: `a69be6edb75c35ed99b44712e5a8e986b45586515bb78ddaeda13c0b4d9b2a9b`
- Canonical Fingerprint: `71cad005580a4c120936b76efe39954226f2e65a4edeaf81a12f2ec4cead793b`
- Governing ADRs: [`docs/ADR-0029.md`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/docs/ADR-0029.md) and [`docs/adr/adr-0002-production-test-harness-ci-cd.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/docs/adr/adr-0002-production-test-harness-ci-cd.tex)


## Scope limits

This rewrite formalizes selected structural and behavioral properties; it does not parse real
packet bytes, does not model the full dissector registry, and does not establish equivalence with
the Wireshark executable. The enterprise additions model decision structure and thresholds only;
they do not deploy or reproduce Zeek, Suricata, Kafka, Elasticsearch, OpenSearch, SIEM or SOAR
systems. Claims in `src/` and the two documents under `docs/` are the only claims made.
