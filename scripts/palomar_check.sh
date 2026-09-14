#!/usr/bin/env bash
# Run the pinned local Comparator/NanoDa check; never submit or publish.
set -euo pipefail
palomar_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
exec python3 "$palomar_root/scripts/palomar_check.py" "$@"
