#!/usr/bin/env bash
set -euo pipefail

if root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  basename "$root"
else
  basename "$PWD"
fi

