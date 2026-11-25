#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

echo "========================================================================"
echo "  Installing Tapwire LexLean Git Pre-Commit Hook"
echo "========================================================================"

if [ ! -d ".git" ]; then
  echo "Initializing git repository on main..."
  git init -b main
fi

chmod +x .githooks/pre-commit
git config core.hooksPath .githooks

if ! git config user.name >/dev/null 2>&1; then
  git config user.name "Tapwire LexLean Subsystem"
fi
if ! git config user.email >/dev/null 2>&1; then
  git config user.email "tapwire-lexlean@multiplicity.internal"
fi

# Fallback copy
mkdir -p .git/hooks
cp .githooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "✅ Pre-commit hook successfully installed."
echo "   Active core.hooksPath: $(git config core.hooksPath)"
echo "========================================================================"
