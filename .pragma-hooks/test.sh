#!/usr/bin/env bash
# This is a Rust workspace with Node/Python tooling, not a standalone Go module.
set -euo pipefail
PRAGMA_HOME="${PRAGMA_HOME:-$(git config --path --get pragma.home || true)}"
PRAGMA_HOME="${PRAGMA_HOME:-$HOME/.pragma}"
if [[ ! -x "$PRAGMA_HOME/lib/format.sh" ]]; then
  printf 'Pragma not found at %s. Set PRAGMA_HOME or rerun install.sh.\n' "$PRAGMA_HOME" >&2
  exit 1
fi
repo=$(git rev-parse --show-toplevel)
cd "$repo"
export PATH="$repo/.pragma-hooks/bin:$PATH"
# shellcheck source=/dev/null
source "$PRAGMA_HOME/lib/common.sh"
PRAGMA_OUTPUT_FORMAT="${PRAGMA_OUTPUT_FORMAT:-gpt}"
pragma_set_context pre-push test
pragma_run cargo test 0 '' '.pragma-hooks/test.sh' 'Rust workspace tests failed' cargo test || record_failure
pragma_run node test 0 '' '.pragma-hooks/test.sh' 'accountability tooling tests failed' \
  node --test --test-isolation=none --test-reporter=spec \
  scripts/check-typechecker-batch.test.mjs scripts/state.test.mjs \
  scripts/goport/compare-tests.test.mjs || record_failure
pragma_run python3 test 0 '' '.pragma-hooks/test.sh' 'API oracle protocol tooling tests failed' \
  python3 scripts/goport/test_api_oracle.py || record_failure
exit_with_status
