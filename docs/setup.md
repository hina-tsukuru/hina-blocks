# docs/setup.md — 新しいMacで作業を始める手順

2台目のMac（会社Mac / 自宅Mac）で環境を作るときの手順書。
**リポジトリをcloneすれば作業ファイルは全部揃う。** ここに書くのは「gitに入らないマシン固有の設定」だけ。

---

## 1. リポジトリを取得

```bash
cd ~/dev
git clone https://github.com/hina-tsukuru/hina-blocks.git
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

## 3. Claude Code をインストール

既に入っていれば飛ばしてよい（`claude --version` で確認）。

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

> **なぜ npm / brew を使わないか**: 2台目のMacは node v15 / Homebrew 3.0.10 と古く、
> どちらも使えなかった。公式インストーラは既存の環境に依存しないため確実。

インストール先は `~/.local/bin` だが、**PATHに入っていないことがある**。
`claude: command not found` になったら `.zshrc` に追記する:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

## 4. Atlassian MCP を接続

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

## 5. GitHubの設定を復元する（リポジトリを作り直した場合のみ）

通常は不要。**リポジトリを作り直したときだけ**実行する。

```bash
./scripts/setup-branch-protection.sh
```

`main` ブランチ保護（PR必須・管理者にも適用・force push禁止）を適用する。
GitHubの設定はGUIで変更してもgitに履歴が残らないため、
**再現できる形でスクリプトに残している**（設定の意図はスクリプト内のコメント参照）。

---

## 6. Xcode

Xcode を App Store からインストール（**容量が大きくダウンロードに1時間近くかかる**）。

確認:

```bash
xcode-select -p
```

`/Applications/Xcode.app/Contents/Developer` のようなパスが出ればOK。

### 6.1 Apple ID を登録する

**Xcode → Settings → Accounts** で Apple ID を追加する。**無料のApple IDでよい**（有料のApple Developer Program は WBS 1.1 で保留中）。

追加すると Team に「(名前) (Personal Team)」が選べるようになる。これがないと実機で動かせない。

### 6.2 ビルド時に出るパスワード要求について

初回ビルド時に **「codesign wants to access key ... in your keychain」** というダイアログが出る。

> ⚠️ 求められているのは **Macのログインパスワード**。Apple ID のパスワードではない。

**「Always Allow」** を選ぶ（「Allow」だとビルドのたびに聞かれる）。

### 6.3 無料署名の制約

- 署名は**7日で失効**する → 週1でXcodeから実機に入れ直す
- Family Controls のような制限付きエンタイトルメントは使えない可能性がある
  （WBS 1.4.2 の時点で判明する）
- Xcode の "Automatically manage signing" は将来 fastlane match に移行予定（WBS 3.3）

### 6.4 ⚠️ 新規ファイルに実名が入らないことの確認

Xcode は既定で **macOSアカウントのフルネーム**を、生成する全ファイルのヘッダーに埋め込む。

```swift
//  Created by <実名> on 2026/07/26.   ← これが入ると公開リポジトリに実名が載る
```

対策として `HinaBlocks.xcodeproj/xcshareddata/IDETemplateMacros.plist` でヘッダーを固定してある。
これは git 管理されているので、**このリポジトリを clone していれば2台目でも自動的に効く**。

ただし念のため、新しいファイルを作った後は確認すること:

```bash
grep -rn "Created by" HinaBlocks --include='*.swift' | grep -v "hina-tsukuru"
```

何も出なければOK。

---

## 7. コミット前の必須チェック

公開リポジトリのため、**実名・個人サイト・メールアドレスの混入**を毎回確認する。

**初回のみ**: チェックしたい語を1行ずつ書いたファイルをローカルに作る。

```bash
vi .private-patterns
```

```
（ここに実名・旧ハンドル・個人サイトのドメインなどを1行ずつ書く）
```

> ⚠️ **このファイルは `.gitignore` 済み。絶対にコミットしないこと。**
> 「隠したい語のリスト」をリポジトリに置くと、それ自体が答えを教えることになる。
> 実際に一度、チェックコマンドの検索パターンとして実名を書いてしまい、
> 匿名を守るための仕組みが匿名を破る状態になった。

**毎回のチェック**:

```bash
git diff --cached | grep -niFf .private-patterns
```

> ⚠️ **`git diff --cached`（ステージ内容）に対して実行すること。**
> 手元のファイルを直しても、ステージされているのが修正前の版なら実名がコミットされる。
> `git status` が `AM` のときは「ステージ済み内容 ≠ 現在のファイル」を意味する。

何も出なければコミットしてよい。

---

## 関連サービス一覧

| サービス | 場所 | 用途 |
|---|---|---|
| GitHub | https://github.com/hina-tsukuru/hina-blocks | コード・記事原本 |
| Jira | https://hinac.atlassian.net （プロジェクト `KAN`） | チケット管理・**進捗の正** |
| Confluence | https://hinac.atlassian.net/wiki （スペース `SD`） | 要件定義ページ |
| X | @hina_tsukuru | 発信（フロー） |
| Zenn | @hinac | 記事（ストック） |

---

## 作業を終えるとき

**未pushの変更をローカルに残さない**（CLAUDE.md の方針）。

```bash
git add -A
git diff --cached | grep -niFf .private-patterns   # ← 何も出ないことを確認してから
git commit -m "docs: 作業内容 (KAN-xx)"
git push
```

> ⚠️ `git add -A` は**無視設定から漏れているファイルも巻き込む**。
> 7章のチェックを飛ばすと、`.private-patterns` 自体がステージされる事故が起きうる。
> **commit の前に必ず1行挟むこと。**

Claude Code のセッションはマシン間で引き継がれない。**作業の文脈はコミットメッセージとPR本文に残す。**
