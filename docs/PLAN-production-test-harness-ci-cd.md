# Implementation Plan — Production-Grade Test Harness, Automated Reporting, and CI/CD

**Project:** `/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production`  
**Reference implementation:** `/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/kuramoto-prism`  
**Governing ADR (proposed):** `docs/adr/adr-0002-production-test-harness-ci-cd.tex`  
**Predecessor ADR:** `docs/adr/adr-0001-network-capture-alert-integration.tex`  
**Date:** 2026-11-23  
**Status:** Proposed — documentation only; no harness code, hooks, or workflow have been created yet.

## 1. Objective

Establish a production-grade, fail-closed verification harness for the LexLean Tapwire rewrite that:

1. wraps the existing `verify.sh` command surface with a single automated runner;
2. emits both human-readable Markdown and machine-readable JSON reports on every run;
3. keeps a stable "latest" report pair plus immutable timestamped copies;
4. runs locally and in CI/CD with identical pass/fail semantics;
5. blocks commits and pull requests on any verification regression;
6. publishes the human-readable report into the GitHub Actions job summary.

This is the same operating pattern used in `kuramoto-prism` (`run_tests.py`, `run-tests.sh`, `reports/`, `.githooks/pre-commit`, `install-hooks.sh`, and `.github/workflows/verify-test.yml`), but the suite content is adapted to this project's Tapwire/pcapng/dissector/filter and enterprise capture/alert formal model. No Kuramoto numerical invariants or scaling claims are copied.

## 2. Current baseline and scope

### 2.1 Frozen formal baseline

The harness implementation must not change formal source. The baseline it is expected to report, until a later ADR amends the model, is:

| Metric | Current value |
| --- | --- |
| LexLean modules | 14 |
| Theorems | 52 |
| Definitions | 99 |
| Inductive types | 24 |
| Structures | 39 |
| Lean toolchain | `leanprover/lean4:v4.32.2` |
| LexLean | `0.4.3`, language `1.2` |
| PrismPM | `0.5.0` |
| Semantic ID | `82a79bd033b89dc60f05bd8f58518b2f5d77d6e10c7b839ae02296ab422611b2` |
| Lean attestation | `d633598a6e4acdde2a11a1ddc39e35eaeb3d8a2d6d61510c5508b266671b2460` |
| PrismPM release | `79af3626858c67b10dad330a8e0a4ece40b728d9cde4072af3c9fe34da4a92b3` |
| Certified Rust export | `a69be6edb75c35ed99b44712e5a8e986b45586515bb78ddaeda13c0b4d9b2a9b` (unchanged) |

### 2.2 In scope

- New runner and shell wrapper.
- Report generator and report schema.
- Baseline/fingerprint comparison.
- Local pre-commit hook and hook installer.
- GitHub Actions verification workflow and report-publishing job.
- Updating `verify.sh` to delegate to the runner so there is one command definition.
- Updating `README.md` and the ADR status after implementation and acceptance.

### 2.3 Out of scope

- New or modified `.lex.tex` modules.
- New formal theorems or changed thresholds from ADR-0001.
- Kuramoto-style oscillator, delay, or order-parameter benchmarks.
- Deployment of Zeek, Suricata, Kafka, Elasticsearch, OpenSearch, SIEM, or SOAR.
- Claims that the harness proves equivalence with the Tapwire executable.

## 3. Harness architecture and suite catalog

### 3.1 Proposed layout

```text
production/
├── run_tests.py                         authoritative suite runner + report generator
├── run-tests.sh                         shell wrapper; calls python3 run_tests.py
├── verify.sh                            becomes a thin delegate to run-tests.sh --quiet
├── tools.lock                           pinned lexlean/prismpm versions + digests (new)
├── scripts/install-tools.sh             pinned, digest-checked CI bootstrap (new)
├── reports/
│   ├── TEST_REPORT_LATEST.md            stable human-readable latest report (committed)
│   ├── test_report_latest.json          stable machine-readable latest report (committed)
│   ├── TEST_REPORT_<UTC>.md             immutable timestamped copy (CI artifact)
│   ├── test_report_<UTC>.json           immutable timestamped copy (CI artifact)
│   └── logs/                            per-suite stdout/stderr (ignored)
├── .githooks/pre-commit                 fail-closed local gate (new)
├── install-hooks.sh                     initializes git if needed and installs hook (new)
└── .github/workflows/verify-test.yml    required CI check + report publishing (new)
```

`run_tests.py` is the single source of truth for suite commands and pass conditions. `run-tests.sh` adds no logic beyond locating Python and forwarding arguments. `verify.sh` keeps its existing user-facing path but delegates to the runner, eliminating duplicated command lists.

### 3.2 Suite catalog

| Suite | Name | Command / evidence | Pass condition |
| --- | --- | --- | --- |
| `TS-01` | Toolchain Pin & Runtime Environment | `lean --version`, `lake --version`, `lexlean --version`, `prismpm --version`, `lean-toolchain` | All commands exit 0; installed versions match the pinned toolchain and `tools.lock`. Version drift fails closed. |
| `TS-02` | Canonical Format & Lock Parity | `lexlean fmt --all --check`, `lexlean lock --check` | Both exit 0; lock output reports that `lexlean.lock` is current. |
| `TS-03` | Lean Lake Host Build & Hygiene | `lake build --allow-empty` | Exit 0; build stdout captured in report and log. |
| `TS-04` | Semantic IR AST & Module Type Check | `lexlean check --all` | Exit 0; stdout parsed for `checked 14 modules`; source and semantic digests extracted. |
| `TS-05` | Lean 4 Kernel Verification & Attestation | `lexlean verify --all` | Exit 0; stdout parsed for `verified 14 modules`; 64-hex attestation extracted; no sorries or dynamic axioms. |
| `TS-06` | Formal Declaration & Threshold Audit | Source scan over all 14 `src/**/*.lex.tex` files | Expected declaration families and counts match the frozen baseline; enterprise thresholds (15/10s, 50/60s, 500/300s, `class_uid*100+activity_id`) are present; forbidden tokens absent. LexLean kernel remains authoritative. |
| `TS-07` | Build & Attestation Artifact Audit | `.lexlean/verified/`, `.lexlean/build/`, `lexlean.lock`, `lexlean.toml`, `prismpm.toml`, `production/request.json` | Required artifacts exist; semantic ID from `TS-04` equals the semantic ID reported by `prismpm check`; attestation is non-empty and stable on rerun. |
| `TS-08` | PrismPM Model Compilation & Production Release | `prismpm check`, `prismpm build` | Both exit 0; published 64-hex hash parsed; `release/build/<hash>/manifest.json` and `release/build/<hash>/model.prism.json` exist. Note: this project's `build_root` is `release`, not `production/build`. |
| `TS-09` | Tapwire/Enterprise Invariant Matrix & Report Integrity | In-process sub-suites `SUITE-W1`, `SUITE-E1`, `SUITE-E2`, `SUITE-E3`, `SUITE-X1`, `SUITE-F1`, `SUITE-R1` | All sub-suites pass; generated JSON and Markdown agree on suite count, status, hashes, and fingerprint. |

Every suite writes its command, exit code, duration, stdout, and stderr to `reports/logs/<suite>_<UTC>.log`. The runner returns exit 0 only when `summary.status == "PASS"`.

### 3.3 Adapted `TS-09` sub-suites

Unlike Kuramoto `TS-09`, this suite is not a numerical stress benchmark. It audits the formal claim families that ADR-0001 introduced and the integrity of the generated reports.

| Sub-suite | Target property | Evidence |
| --- | --- | --- |
| `SUITE-W1` | Tapwire core model coverage | Capture limits/magic values, pcapng block alignment, dissector ordering/depth, filter evaluation, rejection theorems in `src/Tapwire/*` and `src/Main.lex.tex`. |
| `SUITE-E1` | Capture pipeline and normalization | Four-tier ordering, VXLAN/GENEVE termination, worker balancing/buffering, schema field roles, OCSF `type_uid` formula. |
| `SUITE-E2` | File-server threat thresholds | Rules 1–4 predicates and exact documented thresholds: admin share + executable extension; ≥15 distinct targets/10s; ≥50 events/60s; ≥500 events/300s. |
| `SUITE-E3` | Alert operations | Baseline suppression, contextual score threshold, severity mapping, endpoint correlation, SOAR response selection. |
| `SUITE-X1` | Cross-module and top-level integration | `Enterprise.Invariants` joint theorem plus `Main` integration/rejection theorems. |
| `SUITE-F1` | PRISM facets | `Foundation.Arch`, `Foundation.Qual`, `Foundation.Sec` declarations present and counted. |
| `SUITE-R1` | Report integrity | JSON parses; Markdown contains matching status/hashes; latest pair is byte-identical to timestamped pair; semantic fingerprint matches the committed latest report. |

### 3.4 Runner modes

- `python3 run_tests.py` — full run, colored terminal output, writes all artifacts.
- `./run-tests.sh --ci` — UTC timestamps, no color, strict baseline and fingerprint checks, CI-safe paths.
- `./run-tests.sh --hook` — same gates as `--ci`; used by the pre-commit hook.
- `./run-tests.sh --quiet` — used by `verify.sh`; same gates, reduced console output.

There is deliberately no "fast" mode that skips `TS-05` or `TS-08`. Caching may accelerate tool setup; it must not weaken the gate.

## 4. Requirements traceability

| Current module(s) | Formal responsibility | Covering suite |
| --- | --- | --- |
| `Tapwire.Capture`, `Tapwire.PcapNg` | Capture limits, magic values, block alignment | `TS-04`, `TS-05`, `SUITE-W1` |
| `Tapwire.Dissector`, `Tapwire.Filter` | Dissector tree/depth and display-filter evaluation | `TS-04`, `TS-05`, `SUITE-W1` |
| `Tapwire.Invariants` | Cross-module Tapwire invariants | `SUITE-W1` |
| `Enterprise.CapturePipeline`, `Enterprise.Normalization` | Tier order, tunnel handling, schema/OCSF identities | `SUITE-E1` |
| `Enterprise.FileServerThreats` | Four detection rules and thresholds | `SUITE-E2` |
| `Enterprise.AlertOperations` | Suppression, scoring, severity, correlation, SOAR | `SUITE-E3` |
| `Enterprise.Invariants`, `Main` | Joint enterprise + Tapwire integration | `SUITE-X1` |
| `Foundation.Arch`, `Foundation.Qual`, `Foundation.Sec` | PRISM architecture/quality/security facets | `SUITE-F1` |
| Project config, lockfiles, build roots | Canonical serialization, attestation storage, release artifacts | `TS-02`, `TS-07`, `TS-08` |
| Generated reports | Audit trail and documentation freshness | `SUITE-R1` |

## 5. Report contract

### 5.1 Machine-readable JSON

File: `reports/test_report_latest.json` plus `reports/test_report_<UTC>.json`.

Top-level schema identifier: `lexlean-test-report/1`.

Required fields:

```json
{
  "report_schema": "lexlean-test-report/1",
  "timestamp": "YYYYmmddTHHMMSSZ",
  "iso_time": "YYYY-MM-DDTHH:MM:SSZ",
  "fingerprint": "<sha256 over canonical finding fields>",
  "target_directory": "/run/media/multiplic/AGI/prismagi/mount/SUBSYSTEMS/production",
  "git": {"commit": "<sha or null>", "dirty": false},
  "toolchain": {"lean": "...", "lake": "...", "lexlean": "...", "prismpm": "...", "pinned": "..."},
  "formal": {
    "modules_expected": 14,
    "modules_checked": 14,
    "modules_verified": 14,
    "theorems": 52,
    "definitions": 99,
    "inductives": 24,
    "structures": 39,
    "source_hash": "...",
    "semantic_hash": "...",
    "attestation": "..."
  },
  "suites": [{"id": "TS-01", "name": "...", "target": "...", "status": "PASS", "duration": 0.0}],
  "domain_invariants": {"SUITE-W1": {"status": "PASS"}, "SUITE-R1": {"status": "PASS"}},
  "release": {"published_hash": "...", "path": "release/build/<hash>", "export_hash_unchanged": true},
  "summary": {"total": 9, "passed": 9, "failed": 0, "status": "PASS"}
}
```

The `fingerprint` is computed over a canonical JSON projection that excludes volatile fields (`timestamp`, `iso_time`, `duration`, absolute log paths). It therefore changes only when a semantic finding changes. This solves the report-drift problem that a raw byte comparison would create because timestamps differ on every run.

### 5.2 Human-readable Markdown

File: `reports/TEST_REPORT_LATEST.md` plus `reports/TEST_REPORT_<UTC>.md`.

Required sections:

1. Title and status badge (`✅ PASSED` / `❌ FAILED`).
2. UTC execution timestamp, target directory, git commit, toolchain versions.
3. Attestation block: semantic ID, source hash, Lean attestation, PrismPM release, certified Rust export status.
4. Executive summary table: 9 suites, 14 modules, 52 theorems, baseline drift result.
5. Suite matrix: ID, name, command/evidence, result, duration.
6. Module matrix: all 14 modules with one-line responsibility and result.
7. Domain invariant matrix: the seven `TS-09` sub-suites.
8. Artifact audit: lockfile, config, `release/build/<hash>`, logs.
9. Failure section: failing command, exit code, stderr/stdout tail, and remediation hint.

The Markdown report is appended verbatim to `$GITHUB_STEP_SUMMARY` by CI.

### 5.3 Freshness and retention

- Each run writes a timestamped pair and then copies it byte-for-byte to the `*_LATEST.*` pair.
- Only the two latest files are auto-staged by the hook.
- Timestamped reports and `reports/logs/` are retained as CI artifacts; they should be excluded from git by `.gitignore` while the `*_LATEST.*` pair remains tracked.
- CI compares the committed latest report's `fingerprint` with the freshly generated one. A mismatch fails the build with a clear "stale report" message.

## 6. Local developer workflow

### 6.1 Pre-commit hook

`.githooks/pre-commit` will:

1. `cd` to the project root.
2. Print a clear gate banner.
3. Run `./run-tests.sh --hook`.
4. On failure, print the report path and exit non-zero before `git add`ed content is committed.
5. On success, stage exactly:
   - `reports/TEST_REPORT_LATEST.md`
   - `reports/test_report_latest.json`
6. Print a success banner.

It must not `git add reports/` wholesale; that would commit stale timestamped files and logs.

### 6.2 Hook installer

`install-hooks.sh` will mirror the Kuramoto installer but adapt names:

1. Detect missing `.git`; if absent, run `git init -b main`.
2. `chmod +x .githooks/pre-commit`.
3. `git config core.hooksPath .githooks`.
4. Copy the hook to `.git/hooks/pre-commit` as a fallback and chmod it.
5. Print the active `core.hooksPath`.

This project currently has no `.git` directory, so the initialization branch is required, not optional.

## 7. CI/CD pipeline

### 7.1 Workflow

Create `.github/workflows/verify-test.yml` named **Tapwire LexLean Verification and CI Pipeline**.

Triggers:

- `push` to `main` and `master` with path filters for `src/**`, `language/**`, `lexlean.toml`, `lexlean.lock`, `prismpm.toml`, `prismpm.lock`, `lakefile.toml`, `lean-toolchain`, `run_tests.py`, `run-tests.sh`, `verify.sh`, `tools.lock`, `scripts/install-tools.sh`, `.githooks/**`, `install-hooks.sh`, and `.github/workflows/**`.
- `pull_request` to `main` and `master`.
- `workflow_dispatch`.
- `concurrency` group per workflow/ref with `cancel-in-progress: true`.

Required job `verify` on `ubuntu-latest`:

1. `actions/checkout@v4`.
2. `actions/setup-python@v5` with Python 3.11. No `numpy`/`scipy` dependency is needed; the production harness uses the Python standard library only.
3. Install Lean via `leanprover/lean4-action@v1` using `lean-toolchain`.
4. Install pinned LexLean and PrismPM using `tools.lock` + `scripts/install-tools.sh`. The script must verify a SHA-256 digest for every downloaded CLI and fail if `TS-01` reports a version mismatch. The Kuramoto workflow's `# Placeholder or local copy if cached` step is explicitly not acceptable here.
5. Run `./run-tests.sh --ci`.
6. If always: upload `reports/` with `actions/upload-artifact@v4` as `tapwire-lexlean-reports`.
7. If always: append `reports/TEST_REPORT_LATEST.md` to `$GITHUB_STEP_SUMMARY`; if missing, append an explicit failure notice.
8. Fail the job whenever the runner exits non-zero.

Branch protection must require the `verify` status check before merging to `main`.

### 7.2 Report publishing job

Add a `publish-reports` job with `needs: verify` that runs only on `push` to `main`:

- re-download the `tapwire-lexlean-reports` artifact;
- publish it as a GitHub Pages artifact or immutable release asset named `tapwire-lexlean-reports-<UTC>`;
- never modify source, lockfiles, or formal modules.

This is the CD extension beyond the reference repository's CI-only workflow.

### 7.3 Idempotence rule

Two consecutive runs on unchanged source must produce identical `semantic_hash`, `attestation`, `published_hash`, theorem counts, and fingerprint. Only timestamps and durations may differ. Any other difference fails acceptance.

## 8. Phased implementation roadmap

### Phase 1 — Governance (this change)

1. Create this plan.
2. Create `docs/adr/adr-0002-production-test-harness-ci-cd.tex`.
3. Leave formal source, config, and verification scripts untouched.

### Phase 2 — Runner core (`TS-01`…`TS-05`)

1. Create `run_tests.py` and `run-tests.sh`.
2. Implement command execution with isolated PATH, captured stdout/stderr, durations, and UTC timestamps.
3. Implement `TS-01` through `TS-05`, including digest/attestation parsing.
4. Implement JSON and Markdown generation skeleton.

### Phase 3 — Formal and domain gates (`TS-06`…`TS-09`)

1. Implement source declaration/threshold audit.
2. Implement artifact and release audits with this project's `release/build/<hash>` path.
3. Implement the seven `TS-09` sub-suites, including `SUITE-R1`.
4. Add `tools.lock` and pinned installer requirements.

### Phase 4 — Determinism and cutover

1. Add semantic fingerprint and stale-report detection.
2. Change `verify.sh` to delegate to `./run-tests.sh --quiet`.
3. Update `.gitignore` for logs and timestamped reports.
4. Run twice and confirm idempotence.
5. Update `README.md` with harness usage and generated-report paths.

### Phase 5 — Local gates

1. Create `.githooks/pre-commit` and `install-hooks.sh`.
2. Test success path: report pair is auto-staged.
3. Test failure path: an injected failing suite blocks commit.
4. Test missing-`.git` path on a copy of the project.

### Phase 6 — CI/CD

1. Create `.github/workflows/verify-test.yml`.
2. Configure branch protection for `verify`.
3. Validate PR failure path, PR success path, artifact upload, and job summary rendering.
4. Validate `publish-reports` on a main-branch push.

### Phase 7 — Acceptance and ADR closure

1. Mark `ADR-0002` Accepted and record the first harness run's timestamp, fingerprint, and report paths.
2. Confirm ADR-0001 hashes remain unchanged; if the model changes later, amend through a new ADR first.

## 9. Acceptance criteria

- [ ] `python3 run_tests.py` reports 9/9 suites PASS and exits 0.
- [ ] `reports/TEST_REPORT_LATEST.md` and `reports/test_report_latest.json` are generated and agree on all findings.
- [ ] Timestamped report pairs are byte-identical to the latest pair at generation time.
- [ ] Report fingerprints are stable across two consecutive unchanged runs.
- [ ] Reported module/theorem counts are 14/52 and match the frozen baseline; any drift requires an explicit baseline update in the same change set.
- [ ] Semantic ID, Lean attestation, and PrismPM release match ADR-0001/README on unchanged source.
- [ ] `release/build/<hash>/manifest.json` and `model.prism.json` are verified by `TS-08`.
- [ ] `verify.sh` delegates to the runner and still exits 0.
- [ ] Pre-commit hook blocks a failing run and stages only the two latest report files on success.
- [ ] `install-hooks.sh` works with no existing `.git` directory.
- [ ] CI installs pinned, digest-checked tools with no placeholder step.
- [ ] CI uploads reports even on failure and appends the Markdown report to `$GITHUB_STEP_SUMMARY`.
- [ ] Branch protection requires the `verify` check.
- [ ] No `.lex.tex` source file or ADR-0001 artifact is modified by this harness work.

## 10. Risks and mitigations

| Risk | Mitigation |
| --- | --- |
| Hard-coded counts become stale after legitimate model changes. | Store expectations in a checked-in baseline manifest; require explicit baseline update and review in the same PR; report drift as a named finding, not a silent number. |
| CI tool installation placeholder causes environment drift. | `tools.lock` with exact versions and SHA-256 digests; `TS-01` fails on mismatch. |
| Committed Markdown report drifts from source. | Semantic fingerprint excludes timestamps; CI compares committed latest fingerprint to fresh run. |
| Local hook and CI diverge. | Both call the same runner mode semantics; no skip flags that bypass `TS-05` or `TS-08`. |
| Commit latency from full kernel verification. | Accepted trade-off; cache tool installation only. Do not introduce a weaker "fast" gate. |
| Unbounded report growth. | Commit only `*_LATEST.*`; retain timestamped reports as CI artifacts and ignore them in git. |
| Missing git repository. | Installer initializes `main` explicitly. |

## 11. Non-goals

- No new formalization work and no changes to the 14-module model.
- No reproduction of Kuramoto oscillator/delay scaling benchmarks.
- No operational security tooling deployment.
- No hand-edited reports; reports are generated artifacts only.
- No replacement of Lean kernel verification by source scanning; source scanning supplements, never overrides, `lexlean verify --all`.
