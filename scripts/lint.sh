#!/usr/bin/env bash
# SwiftLint をリポジトリ全体に実行する（WBS 1.5 / KAN-15）
# 使い方: scripts/lint.sh          … 警告も含めて表示
#         scripts/lint.sh --strict … 警告もエラー扱い（CI 用。Phase 3 で使う）
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v swiftlint >/dev/null 2>&1; then
  echo "swiftlint が見つかりません。brew install swiftlint を実行してください（docs/setup.md 参照）" >&2
  exit 1
fi

swiftlint lint "$@"
