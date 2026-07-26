#!/usr/bin/env bash
#
# main ブランチの保護設定を適用する
#
# ■ なぜスクリプトにしているか
#   GitHubの設定はGUIで変更してもgitに履歴が残らない。
#   「半年後になぜこの設定なのか分からない」を防ぐため、
#   設定内容をコードとして残し、リポジトリを作り直しても再現できるようにしている。
#   （Terraform等のInfrastructure as Codeの簡易版という位置づけ）
#
# ■ 使い方
#   ./scripts/setup-branch-protection.sh
#
# ■ 前提
#   - gh CLI がインストール済み（brew install gh）
#   - gh auth login 済み
#
set -euo pipefail

REPO="hina-tsukuru/hina-blocks"
BRANCH="main"

echo "対象: ${REPO} の ${BRANCH} ブランチ"
echo

# --- 前提チェック ---------------------------------------------------------
if ! command -v gh > /dev/null 2>&1; then
  echo "エラー: gh CLI が見つかりません。'brew install gh' を実行してください。" >&2
  exit 1
fi

if ! gh auth status > /dev/null 2>&1; then
  echo "エラー: GitHubにログインしていません。'gh auth login' を実行してください。" >&2
  exit 1
fi

# --- 設定の適用 -----------------------------------------------------------
#
# 各設定の意図（1人開発向けのチューニング）:
#
#   enforce_admins: true
#     「管理者にも適用」。falseにすると、リポジトリ所有者だけが保護を
#     素通りできる。1人開発では所有者＝作業者なので、falseだと保護が
#     完全に無意味になる。ここは必ず true。
#
#   required_approving_review_count: 0
#     承認は不要にする。GitHubは自分のPRを自分で承認することを禁止して
#     いるため、1人開発で1以上にすると永久にマージできなくなる。
#     0でもPR作成自体は必須なので、「差分の強制確認」と「記録を残す」
#     という目的は達成できる。
#
#   allow_force_pushes / allow_deletions: false
#     履歴の破壊とmainの誤削除を防ぐ。
#
gh api -X PUT "repos/${REPO}/branches/${BRANCH}/protection" --input - > /dev/null <<'JSON'
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 0,
    "dismiss_stale_reviews": false,
    "require_code_owner_reviews": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON

echo "適用しました。現在の設定:"
gh api "repos/${REPO}/branches/${BRANCH}/protection" \
  --jq '{
    "PR必須": (.required_pull_request_reviews != null),
    "必要承認数": .required_pull_request_reviews.required_approving_review_count,
    "管理者にも適用": .enforce_admins.enabled,
    "force_push許可": .allow_force_pushes.enabled,
    "ブランチ削除許可": .allow_deletions.enabled
  }'

echo
echo "※ 設定しただけで満足しないこと。実際に main へ直接pushを試すと"
echo "   'GH006: Protected branch update failed' で拒否されるのが正常な状態。"
