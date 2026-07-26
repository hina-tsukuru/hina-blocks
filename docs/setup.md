# docs/setup.md — 新しいMacで作業を始める手順

2台目のMac（会社Mac / 自宅Mac）で環境を作るときの手順書。
**リポジトリをcloneすれば作業ファイルは全部揃う。** ここに書くのは「gitに入らないマシン固有の設定」だけ。

---

## 1. リポジトリを取得

```bash
cd ~/dev
git clone <リポジトリURL> hina-blocks
cd hina-blocks
```

これで `docs/` `content/` `CLAUDE.md` が揃う。**作業の文脈は全部ここにある**（WBS・要件・キャラ設定・記事）。

---

## 2. git の名前とメールを設定

⚠️ **コミットの author 名とメールは GitHub 上で公開される。** リポジトリを公開する場合、ここに実名や実メールを入れるとヒナの匿名運用が崩れる。

このリポジトリ限定で設定する（他プロジェクトに影響しない）:

```bash
git config user.name "<決めた名前>"
git config user.email "<決めたメール>"
```

※ 1台目で使った設定と**必ず揃える**こと。バラバラだとコミット履歴に別人が現れる。

---

## 3. Atlassian MCP を接続

**この設定はマシンごとに必要**（`~/.claude.json` に保存されるため、gitでは共有されない）。

```bash
claude mcp add -s user --transport http atlassian https://mcp.atlassian.com/v1/mcp
```

その後、インタラクティブな `claude` の中で:

```
/mcp
```

→ `atlassian` を選択 → **Authenticate** → ブラウザでAtlassianにログイン → 許可

確認:

```bash
claude mcp list
```

`atlassian: ... ✔ Connected` と出れば成功。

### ハマりどころ

| 症状 | 原因と対処 |
|---|---|
| プロジェクトから `No MCP servers configured` | `-s user` を付け忘れた。カレントディレクトリ限定で登録されている。remove して `-s user` 付きで再登録 |
| `Needs authentication` | `/mcp` → Authenticate を実行していない |
| ツールが使えない（`✔ Connected` なのに） | Claude Code の**再起動**が必要。起動時にMCPを読み込むため |
| Confluenceだけ 403 `The app is not installed` | Confluenceのスコープが認証に入っていない。`/mcp` で再認証 |

---

## 4. GitHubの設定を復元する（リポジトリを作り直した場合のみ）

通常は不要。**リポジトリを作り直したときだけ**実行する。

```bash
./scripts/setup-branch-protection.sh
```

`main` ブランチ保護（PR必須・管理者にも適用・force push禁止）を適用する。
GitHubの設定はGUIで変更してもgitに履歴が残らないため、
**再現できる形でスクリプトに残している**（設定の意図はスクリプト内のコメント参照）。

---

## 5. Xcode（Phase 1.4 以降）

- Xcode をインストール（App Store。**ダウンロードに時間がかかる／容量が大きい**）
- 署名は**無料Apple IDで進行中**（WBS 1.1 は保留）
  - 無料署名は**7日で失効**するため、週1でXcodeから実機に入れ直す
  - Family Controls capability を追加する時点で、有料メンバーシップの要否が判明する
- ⚠️ Xcode の "Automatically manage signing" は将来 fastlane match に移行予定（WBS 3.3）

---

## 関連サービス一覧

| サービス | 場所 | 用途 |
|---|---|---|
| Jira | https://hinac.atlassian.net （プロジェクト `KAN`） | チケット管理 |
| Confluence | https://hinac.atlassian.net/wiki （スペース `SD`） | 要件定義ページ |
| X | @hina_tsukuru | 発信（フロー） |
| Zenn | @hinac | 記事（ストック） |
| GitHub | ※WBS 1.2 で作成 | コード・記事原本 |

---

## 作業を終えるとき

**未pushの変更をローカルに残さない**（CLAUDE.md の方針）。

```bash
git add -A
git commit -m "docs: 作業内容 (KAN-xx)"
git push
```

Claude Code のセッションはマシン間で引き継がれない。**作業の文脈はコミットメッセージとPR本文に残す。**
