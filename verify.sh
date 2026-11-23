#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
./run-tests.sh --quiet "$@"
