#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p logs

case "${1:-}" in
  '') nivat_build_log=logs/build.log ;;
  --clean)
    if [[ -d .lake/build ]]; then
      nivat_build_backup=$(mktemp -d "${TMPDIR:-/tmp}/nivat-build.XXXXXX")
      mv .lake/build "$nivat_build_backup/build"
      echo "Project build directory preserved at $nivat_build_backup/build"
    fi
    nivat_build_log=logs/clean-build.log
    ;;
  *) echo 'Usage: bash scripts/verify.sh [--clean]' >&2; exit 2 ;;
esac

run_logged() {
  local nivat_log=$1
  shift
  {
    printf '$'
    printf ' %q' "$@"
    printf '\n'
    "$@"
    echo 'EXIT_CODE=0'
  } 2>&1 | tee "$nivat_log"
}

run_logged "$nivat_build_log" lake build
run_logged logs/axioms.log lake env lean scripts/Audit.lean
run_logged logs/axiom-allowlist.log python3 scripts/check_axioms.py scripts/Audit.lean logs/axioms.log
run_logged logs/raw-statements.log lake env lean scripts/RawStatements.lean
run_logged logs/raw-axiom-allowlist.log python3 scripts/check_axioms.py scripts/RawStatements.lean logs/raw-statements.log
run_logged logs/kernel-replay.log lake env leanchecker --verbose Nivat
run_logged logs/solution-kernel-replay.log lake env leanchecker --verbose Solution
run_logged logs/source-audit.log python3 scripts/source_audit.py
