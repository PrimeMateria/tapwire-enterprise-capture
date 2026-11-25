# Tapwire Enterprise Capture — Formal Verification Suite (LexLean)

[![Lean 4](https://img.shields.io/badge/Lean_4-v4.32.2-blue.svg)](https://leanprover.github.io/)
[![LexLean](https://img.shields.io/badge/LexLean-Language_1.0-green.svg)](https://github.com/)
[![PrismPM](https://img.shields.io/badge/PrismPM-v0.5.0-orange.svg)](https://github.com/)
[![Status](https://img.shields.io/badge/Verification-100%25_Passing_(9%2F9)-brightgreen.svg)]()
[![Attestation](https://img.shields.io/badge/Attestation-d633598a...-purple.svg)](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/reports/TEST_REPORT_LATEST.md)
[![PrismPM Release](https://img.shields.io/badge/Release-79af3626...-blueviolet.svg)](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/release/build/79af3626858c67b10dad330a8e0a4ece40b728d9cde4072af3c9fe34da4a92b3)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-Pre--Commit%20%2B%20GHA-success.svg)](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/.github/workflows/verify-test.yml)

Formal specification, interactive theorem verification, enterprise network security pipeline integration, automated 9-suite verification harness, and CI/CD pre-commit enforcement for the Tapwire subsystem. Authored in **LexLean** with full **Lean 4 kernel** formal attestation and published into production using **PrismPM**.

- **Subsystem Target**: [`/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production)
- **Reference Pattern**: [`/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/kuramoto-prism`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/kuramoto-prism)
- **Original Empirical Subsystem**: [`/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/tapwire`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/tapwire)
- **Governing Architecture Records**:
  - [ADR-0001: Network Capture and Alert Integration](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/docs/adr/adr-0001-network-capture-alert-integration.tex) (LaTeX Subsystem Record)
  - [ADR-0002: Production-Grade Test Harness and Automated Reporting](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/docs/adr/adr-0002-production-test-harness-ci-cd.tex) (LaTeX Subsystem Record)
  - [ADR-0029: Production-Grade Test Harness and Automated Reporting](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/docs/ADR-0029.md) (PRISM Global Index Record)
  - [PLAN-production-test-harness-ci-cd.md](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/docs/PLAN-production-test-harness-ci-cd.md) (Subsystem Technical Plan)
- **Lean Kernel Attestation Hash**: `d633598a6e4acdde2a11a1ddc39e35eaeb3d8a2d6d61510c5508b266671b2460`
- **Semantic IR Digest**: `82a79bd033b89dc60f05bd8f58518b2f5d77d6e10c7b839ae02296ab422611b2`
- **PrismPM Immutable Release**: `79af3626858c67b10dad330a8e0a4ece40b728d9cde4072af3c9fe34da4a92b3`
- **Deterministic Semantic Fingerprint**: `71cad005580a4c120936b76efe39954226f2e65a4edeaf81a12f2ec4cead793b`

---

## 1. Executive Summary

The **Tapwire Enterprise Capture Subsystem** provides a closed-lexicon, kernel-verified formal specification of packet capture foundations, block alignment bounds, protocol dissector hierarchies, display filter AST evaluations, and enterprise-grade threat analytics.

Created as a formal alternative to the 495 MB C/C++ Tapwire implementation, this project unifies bounded protocol mechanics with the enterprise security requirements from [`Network Capture and Alert Planning.txt`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/Network%20Capture%20and%20Alert%20Planning.txt) under the rigorous PRISM architecture:

1. **100% Lean 4 Kernel Attestation**: 14 formal modules (5 Tapwire protocol modules + 5 Enterprise capture/threat modules + 1 Joint Integration module + 3 PRISM foundation facets) verified by the Lean 4 kernel with **0 errors, 0 sorries, and 0 dynamic tactic axioms**.
2. **Formal Protocol Model**:
   - **Capture Bounds**: Enforces snaplen constraints ($1 \dots 262144$), link type ranges, and magic header signatures (`PCAP: 0xa1b2c3d4`, `PCAPNG: 0x0a0d0d0a`).
   - **PcapNg Alignment**: Verifies 32-bit boundary alignment, total block length constraints, and section/interface/packet block validators.
   - **Dissector Hierarchy**: Models tree structure, field registry uniqueness, protocol layer ordering, and recursion budget constraints ($\le 32$).
   - **Display Filter Soundness**: Establishes evaluator soundness over filter expression trees with node count bounds ($\le 64$) and boolean short-circuit evaluation.
3. **Enterprise Pipeline & Threat Detection (ADR-0001)**:
   - **Four-Tier Architecture**: Verified sequential flow from Acquisition $\to$ Sensors $\to$ Transport $\to$ Storage with VXLAN/GENEVE tunnel stripping and load-balanced buffering.
   - **OCSF Normalization**: Enforces schema identity mapping $\mathrm{type\_uid} = \mathrm{class\_uid} \times 100 + \mathrm{activity\_id}$ across ECS, UDM, and OCSF taxonomies.
   - **Four Threat Detection Rules**: Exact thresholds formally audited for administrative share payload execution, share enumeration ($\ge 15$ targets / 10s), ransomware renaming ($\ge 50$ operations / 60s), and mass exfiltration ($\ge 500$ events / 300s).
   - **Alert Operations & SOAR**: Baseline alert suppression, contextual threat score evaluation ($\ge 80.0$ critical severity), multi-source correlation, and automated SOAR host containment codes.
4. **Authoritative 9-Suite Verification Harness (ADR-0029 / ADR-0002)**:
   - Single authoritative runner ([`run_tests.py`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/run_tests.py)) and shell wrapper ([`run-tests.sh`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/run-tests.sh)).
   - Dual reporting engine emitting synchronized human-readable Markdown ([`reports/TEST_REPORT_LATEST.md`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/reports/TEST_REPORT_LATEST.md)) and schema-compliant JSON ([`reports/test_report_latest.json`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/reports/test_report_latest.json)).
   - Invariant canonical semantic fingerprinting to prevent spurious CI failures while detecting genuine proof debt.
5. **Fail-Closed Git Pre-Commit & CI Automation**:
   - Active pre-commit gate ([`.githooks/pre-commit`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/.githooks/pre-commit)) that halts commits on verification regression and auto-stages verified reports.
   - Pinned toolchain bootstrap ([`tools.lock`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/tools.lock), [`scripts/install-tools.sh`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/scripts/install-tools.sh)).
   - GitHub Actions CI workflow ([`.github/workflows/verify-test.yml`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/.github/workflows/verify-test.yml)) publishing to `$GITHUB_STEP_SUMMARY`.

---

## 2. Reflection of Current State

The subsystem is in a fully verified, self-governing, and committed production state:

- **Repository Branch**: `main`
- **Initial Baseline Commit**: [`2a0231b`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/.git) (`feat(ci): implement 9-suite test harness, automated reporting, and pre-commit gate (ADR-0029)`)
- **Working Tree**: Clean (all code, models, docs, scripts, locks, and report ledgers tracked).
- **Toolchain Alignment**: Strictly pinned to `leanprover/lean4:v4.32.2`, `Lake 5.0.0`, `LexLean 0.4.3`, and `PrismPM 0.5.0`.
- **Pre-Commit Enforcement**: `.githooks/pre-commit` active via `core.hooksPath = .githooks`; tested and validated against real commit cycles.
- **Verification Status**: 9 of 9 test suites pass with 100% success rate across all modules.
- **Idempotence & Determinism**: Validated across consecutive runs. The semantic fingerprint (`71cad005580a...`) remains identical across executions.
- **Published Production Release**: Verified and sealed under [`release/build/79af3626858c67b10dad330a8e0a4ece40b728d9cde4072af3c9fe34da4a92b3/`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/release/build/79af3626858c67b10dad330a8e0a4ece40b728d9cde4072af3c9fe34da4a92b3).
- **Certified Rust Bundle**: Exported to `.lexlean/production/a69be6edb75c.../` with complete machine proofs and evidence manifests.

---

## 3. Test Results & Verification Matrix

### 3.1 Verification Summary

| Metric | Result | Target / Standard | Status |
| :--- | :--- | :--- | :---: |
| **Total Test Suites** | **9 / 9 Passed** | 100% suite success | ✅ PASS |
| **Formal Modules** | **14 / 14 Verified** | 14 `.lex.tex` modules | ✅ PASS |
| **Theorems Certified** | **52 / 52 Proven** | Pure Lean 4 kernel reflexivity | ✅ PASS |
| **Definitions & Types** | **99 Defs, 39 Structs, 24 Inductives** | Closed formal ontology | ✅ PASS |
| **Axiom Policy** | **0 Sorries, 0 Dynamic Axioms** | Pure kernel reflexivity | ✅ PASS |
| **PrismPM Release** | **Build Hash `79af362685...`** | `release/build/<hash>/` sealed | ✅ PASS |
| **Domain Invariant Matrix** | **7 / 7 Sub-Suites Passed** | `SUITE-W1` through `SUITE-R1` | ✅ PASS |
| **Canonical Fingerprint** | `71cad005580a4c12...` | Invariant across unchanged runs | ✅ PASS |

### 3.2 9-Suite Test Matrix (`run_tests.py`)

| Suite ID | Suite Name | Execution Command / Target | Result | Duration |
| :--- | :--- | :--- | :---: | :---: |
| **TS-01** | Toolchain Pin & Runtime Environment | `lean`, `lake`, `lexlean`, `prismpm` binary versions | ✅ PASS | 0.250s |
| **TS-02** | Canonical Format & Lock Parity | `lexlean fmt --all --check` & `lexlean lock --check` | ✅ PASS | 1.607s |
| **TS-03** | Lean Lake Host Build & Hygiene | `lake build --allow-empty` | ✅ PASS | 0.163s |
| **TS-04** | Semantic IR AST & Module Type Check | `lexlean check --all` (14 modules) | ✅ PASS | 0.758s |
| **TS-05** | Lean 4 Kernel Formal Attestation | `lexlean verify --all` (14 modules) | ✅ PASS | 327.622s |
| **TS-06** | Formal Declaration & Threshold Audit | AST scan: 52 theorems, 99 defs, 39 structs, 24 inductives | ✅ PASS | 0.003s |
| **TS-07** | Build & Attestation Artifact Audit | Inspect `.lexlean/`, `lexlean.lock`, `production/request.json` | ✅ PASS | 0.000s |
| **TS-08** | PrismPM Release Compilation | `prismpm check` & `prismpm build` | ✅ PASS | 6.130s |
| **TS-09** | Tapwire & Enterprise Invariant Matrix | In-process sub-suites `SUITE-W1` through `SUITE-R1` | ✅ PASS | 0.002s |

### 3.3 Formally Verified Module Ledger

| Module | Source File | Formal Responsibility & Certified Properties | Result |
| :--- | :--- | :--- | :---: |
| `Tapwire.Capture` | [`src/Tapwire/Capture.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Tapwire/Capture.lex.tex) | Snaplen bounds ($1 \dots 262144$), link type validity, magic numbers (`0xa1b2c3d4`, `0x0a0d0d0a`). | ✅ PASS |
| `Tapwire.PcapNg` | [`src/Tapwire/PcapNg.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Tapwire/PcapNg.lex.tex) | 32-bit block boundary alignment, Section Header Block, Interface & Enhanced Packet Blocks. | ✅ PASS |
| `Tapwire.Dissector` | [`src/Tapwire/Dissector.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Tapwire/Dissector.lex.tex) | Protocol hierarchy, dissector field registry, parent bounds, recursion depth limit ($\le 32$). | ✅ PASS |
| `Tapwire.Filter` | [`src/Tapwire/Filter.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Tapwire/Filter.lex.tex) | Display filter expression AST recursive evaluation, node count budget ($\le 64$), boolean logic. | ✅ PASS |
| `Tapwire.Invariants` | [`src/Tapwire/Invariants.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Tapwire/Invariants.lex.tex) | Joint cross-module packet capture, alignment, dissector depth, and display filter invariants. | ✅ PASS |
| `Enterprise.CapturePipeline` | [`src/Enterprise/CapturePipeline.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Enterprise/CapturePipeline.lex.tex) | 4-tier pipeline ordering (Acquisition $\to$ Sensors $\to$ Transport $\to$ Storage), VXLAN/GENEVE tunnel stripping. | ✅ PASS |
| `Enterprise.Normalization` | [`src/Enterprise/Normalization.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Enterprise/Normalization.lex.tex) | ECS, UDM, and OCSF schema identity: $\mathrm{type\_uid} = \mathrm{class\_uid} \times 100 + \mathrm{activity\_id}$. | ✅ PASS |
| `Enterprise.FileServerThreats` | [`src/Enterprise/FileServerThreats.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Enterprise/FileServerThreats.lex.tex) | Rules 1–4 thresholds: Admin share payload, traversal ($\ge 15$/10s), ransomware ($\ge 50$/60s), exfiltration ($\ge 500$/300s). | ✅ PASS |
| `Enterprise.AlertOperations` | [`src/Enterprise/AlertOperations.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Enterprise/AlertOperations.lex.tex) | Scheduled baseline suppression, contextual threat score threshold ($\ge 80.0$), host correlation, SOAR containment. | ✅ PASS |
| `Enterprise.Invariants` | [`src/Enterprise/Invariants.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Enterprise/Invariants.lex.tex) | End-to-end enterprise integration soundness theorem linking pipeline, threat detection, and SOAR response. | ✅ PASS |
| `Main` | [`src/Main.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Main.lex.tex) | Top-level joint integration and packet rejection theorems uniting Tapwire and enterprise models. | ✅ PASS |
| `Foundation.Arch` | [`src/Foundation/Arch.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Foundation/Arch.lex.tex) | ISO-42010 Architecture description model & component topology. | ✅ PASS |
| `Foundation.Qual` | [`src/Foundation/Qual.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Foundation/Qual.lex.tex) | ISO-25010 Quality characteristics & verification metrics. | ✅ PASS |
| `Foundation.Sec` | [`src/Foundation/Sec.lex.tex`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/src/Foundation/Sec.lex.tex) | ISO-27005/ISO-27034 Security risk, threats, & controls. | ✅ PASS |

### 3.4 Domain Invariant Matrix (`TS-09`)

| Sub-Suite | Target Property | Formal Invariant / In-Process Audit | Result |
| :--- | :--- | :--- | :---: |
| `SUITE-W1` | Tapwire Protocol Coverage | Capture limits, 32-bit block boundary alignment, dissector tree depth ($\le 32$), filter AST bounds. | ✅ PASS |
| `SUITE-E1` | Pipeline & Normalization | 4-tier pipeline ordering, VXLAN/GENEVE tunnel decapsulation, OCSF identity formula $\mathrm{type\_uid} = \mathrm{class\_uid} \times 100 + \mathrm{activity\_id}$. | ✅ PASS |
| `SUITE-E2` | Threat Rules & Thresholds | Rule 1 Admin share executable, Rule 2 traversal ($\ge 15$/10s), Rule 3 ransomware ($\ge 50$/60s), Rule 4 exfiltration ($\ge 500$/300s). | ✅ PASS |
| `SUITE-E3` | Alert Ops & SOAR Response | Baseline suppression, critical score threshold ($\ge 80.0$), host correlation, automated SOAR host isolation. | ✅ PASS |
| `SUITE-X1` | Joint System Integration | `Enterprise.Invariants` joint soundness and `Main` top-level joint consistency theorems. | ✅ PASS |
| `SUITE-F1` | PRISM Foundation Facets | ISO-42010 Architecture (Arch), ISO-25010 Quality (Qual), ISO-27005 Security (Sec) facet declarations. | ✅ PASS |
| `SUITE-R1` | Report & Fingerprint Parity | JSON and Markdown schema alignment, immutable copy identity, canonical fingerprint invariance. | ✅ PASS |

---

## 4. Directory Layout

```text
/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/
├── lexlean.toml / lexlean.lock       Canonical LexLean project specification + lockfile
├── prismpm.toml                      PrismPM production model configuration (build_root = "release")
├── language/                         Closed lexicon titles (tapwire.titles + prism.arch.*)
├── src/                              14 canonical .lex.tex formal modules
│   ├── Tapwire/                    Tapwire capture, pcapng, dissector, filter, & invariants
│   ├── Enterprise/                   Enterprise capture, normalization, threat rules, alert ops, & invariants
│   ├── Foundation/                   PRISM ISO-42010/25010/27005 architecture/quality/security facets
│   └── Main.lex.tex                  Top-level system integration module
├── docs/                             Architecture documentation and planning
│   ├── ADR-0029.md                   Global PRISM Index ADR (Harness, Reporting, Pre-Commit)
│   ├── PLAN-production-test-harness-ci-cd.md  Subsystem test harness implementation plan
│   ├── PLAN-network-capture-alert-integration.md Subsystem integration plan
│   └── adr/
│       ├── adr-0001-network-capture-alert-integration.tex   Subsystem LaTeX ADR (ADR-0001)
│       └── adr-0002-production-test-harness-ci-cd.tex       Subsystem LaTeX ADR (ADR-0002)
├── production/request.json           LexLean production certified Rust export specification
├── release/build/<hash>/             PrismPM published release (manifest.json, model.prism.json)
├── .lexlean/production/<hash>/       Exported certified Rust library and kernel evidence
├── .lexlean/build/                   Content-addressed Lean olean and IR build outputs
├── run_tests.py                     Authoritative 9-suite test runner and report engine
├── run-tests.sh                     POSIX shell runner wrapper with environment isolation
├── tools.lock                       Pinned tool versions and SHA-256 digests
├── scripts/install-tools.sh         Cryptographic tool bootstrap and verification
├── reports/                         Automated verification reports
│   ├── TEST_REPORT_LATEST.md        Human-readable latest report (version-controlled)
│   ├── test_report_latest.json      Machine-readable latest report (version-controlled)
│   └── logs/                        Per-suite raw execution logs (git-ignored)
├── .githooks/pre-commit             Local pre-commit verification gate
├── install-hooks.sh                 Git repository initializer and hook installer
├── .github/workflows/verify-test.yml GitHub Actions CI/CD workflow
├── verify.sh                        Thin execution delegate to ./run-tests.sh --quiet
└── Network Capture and Alert Planning.txt Source enterprise requirements document
```

---

## 5. Test Harness & Developer Workflow

### 5.1 Executing Verification Suites

Execute all 9 verification suites using the authoritative runner:

```bash
# Recommended: POSIX shell wrapper
./run-tests.sh

# Or directly with Python 3:
python3 run_tests.py
```

Runner command-line flags:
- `--ci`: CI mode. Emits strict UTC timestamps, disables ANSI color formatting, and enforces fail-closed exit codes.
- `--hook`: Pre-commit hook mode. Halts git commits on any failure and automatically stages updated reports upon passing.
- `--quiet`: Reduced output mode used by automated delegator scripts (`verify.sh`).

### 5.2 Local Pre-Commit Hook

Install the local pre-commit hook gate:

```bash
./install-hooks.sh
```

Once installed, every `git commit`:
1. Executes `./run-tests.sh --hook`.
2. Validates all 9 verification suites, Lean 4 kernel formal proofs, and PrismPM releases.
3. Automatically stages updated `reports/TEST_REPORT_LATEST.md` and `reports/test_report_latest.json`.
4. Aborts the commit if any test suite, proof, or invariant check fails.

### 5.3 Automated Reports

Every test execution generates synchronized report pairs in [`reports/`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/reports):
- **Human-Readable**: [`reports/TEST_REPORT_LATEST.md`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/reports/TEST_REPORT_LATEST.md)
- **Machine-Readable**: [`reports/test_report_latest.json`](file:///run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production/reports/test_report_latest.json)
- **Execution Logs**: Detailed per-suite log files in `reports/logs/<suite>_<timestamp>.log`.

---

## 6. Attestation & Kernel Axiom Policy

All formal statements in this project are verified strictly through the Lean 4 kernel with:
- **Zero dynamic tactic axioms**
- **Zero unverified assumptions**
- **Zero `sorry` or `sorryAx` references**

### Attestation Fingerprints
- **Lean Kernel Attestation Hash**: `d633598a6e4acdde2a11a1ddc39e35eaeb3d8a2d6d61510c5508b266671b2460`
- **Semantic IR Digest**: `82a79bd033b89dc60f05bd8f58518b2f5d77d6e10c7b839ae02296ab422611b2`
- **PrismPM Production Release**: `79af3626858c67b10dad330a8e0a4ece40b728d9cde4072af3c9fe34da4a92b3`
- **Certified Rust Bundle**: `a69be6edb75c35ed99b44712e5a8e986b45586515bb78ddaeda13c0b4d9b2a9b`
- **Canonical Deterministic Fingerprint**: `71cad005580a4c120936b76efe39954226f2e65a4edeaf81a12f2ec4cead793b`

---

## 7. Scope Boundaries

This rewrite formalizes selected structural and behavioral properties; it does not parse arbitrary packet bytes, does not model the full C dissector registry, and does not claim bit-for-bit equivalence with the native Tapwire C/C++ executable. 

The enterprise additions formalize capture tier ordering, schema normalization, threat rules, and alert operations; they do not run active Zeek, Suricata, Kafka, OpenSearch, SIEM, or SOAR server processes. All formal claims made by the subsystem are bounded strictly to `src/` and the governing architecture records in `docs/`.
