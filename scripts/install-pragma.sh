#!/usr/bin/env bash
# Install the repository's checked-in Pragma configuration without regenerating it.
# usage: PRAGMA_HOME=/path/to/pragma scripts/install-pragma.sh
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo"
pragma_home="${PRAGMA_HOME:-$HOME/.pragma}"
[[ -x "$pragma_home/lib/format.sh" ]] || {
  echo "Install Pragma from https://github.com/zakstak/pragma first; set PRAGMA_HOME." >&2
  exit 1
}
git config --local pragma.home "$pragma_home"
# prek invokes an existing <hook>.legacy alongside its own checks. Preserve the
# public-history guard on fresh clones and after Pragma bootstrap regeneration.
hooks=$(git rev-parse --git-common-dir)/hooks
mkdir -p "$hooks"
install -m 755 scripts/git-hooks/pre-push "$hooks/pre-push.legacy"
prek install --hook-type pre-commit --hook-type pre-push
