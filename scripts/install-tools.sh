#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${SCRIPT_DIR}"

echo "========================================================================"
echo "  Wireshark LexLean CI Tool Bootstrap & SHA-256 Integrity Verifier"
echo "========================================================================"

BIN_DIR="${HOME}/.local/bin"
mkdir -p "${BIN_DIR}"
export PATH="${BIN_DIR}:${PATH}"

EXPECTED_LEXLEAN_SHA="f943d51f5684760c8a904156904823058a7f2d94281373fc5d59454659bf023c"
EXPECTED_PRISMPM_SHA="8cf7e3493b07e0e0b8bd4d9e0719702384259539a3861b21609f15b9c4a5f49b"

verify_binary() {
  local name="$1"
  local path="$2"
  local expected_sha="$3"

  if [ ! -f "${path}" ]; then
    echo "❌ Error: Binary ${name} not found at ${path}"
    return 1
  fi

  local actual_sha
  actual_sha=$(sha256sum "${path}" | awk '{print $1}')

  if [ "${actual_sha}" != "${expected_sha}" ]; then
    echo "❌ Error: SHA-256 mismatch for ${name}!"
    echo "   Expected: ${expected_sha}"
    echo "   Actual:   ${actual_sha}"
    return 1
  fi

  echo "✅ ${name} verified (SHA-256: ${actual_sha})"
  return 0
}

if command -v lexlean &>/dev/null && command -v prismpm &>/dev/null; then
  echo "Inspecting installed tools..."
  verify_binary "lexlean" "$(which lexlean)" "${EXPECTED_LEXLEAN_SHA}"
  verify_binary "prismpm" "$(which prismpm)" "${EXPECTED_PRISMPM_SHA}"
else
  echo "Installing tools from local cache or pre-built release repository..."
  # If running in local container / developer environment, copy from existing paths
  for candidate in /home/multiplic/.local/bin/lexlean /usr/local/bin/lexlean; do
    if [ -f "${candidate}" ]; then
      cp "${candidate}" "${BIN_DIR}/lexlean"
      chmod +x "${BIN_DIR}/lexlean"
      break
    fi
  done
  for candidate in /home/multiplic/.local/bin/prismpm /usr/local/bin/prismpm; do
    if [ -f "${candidate}" ]; then
      cp "${candidate}" "${BIN_DIR}/prismpm"
      chmod +x "${BIN_DIR}/prismpm"
      break
    fi
  done

  verify_binary "lexlean" "${BIN_DIR}/lexlean" "${EXPECTED_LEXLEAN_SHA}"
  verify_binary "prismpm" "${BIN_DIR}/prismpm" "${EXPECTED_PRISMPM_SHA}"
fi

echo "========================================================================"
echo "  All CI tools verified successfully."
echo "========================================================================"
