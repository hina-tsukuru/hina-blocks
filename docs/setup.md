# docs/setup.md — 新しいMacで作業を始める手順

2台目のMac（会社Mac / 自宅Mac）で環境を作るときの手順書。
**リポジトリをcloneすれば作業ファイルは全部揃う。** ここに書くのは「gitに入らないマシン固有の設定」だけ。

---

## 1. リポジトリを取得

```bash
mkdir -p ~/AIProjects/repos && cd ~/AIProjects/repos
git clone https://github.com/hina-tsukuru/hina-blocks.git
cd hina-blocks
```

これで `docs/` `content/` `CLAUDE.md` が揃う。**作業の文脈は全部ここにある**（WBS・要件・キャラ設定・記事）。

> 置き場所は `~/AIProjects/repos/hina-blocks` に統一する（2026-09-27）。
> `~/dev` → `~/AI` → `~/AIProjects/repos` と2回移動しており、そのたびに手順書が取り残された。
> `mkdir -p` を付けてあるので、フォルダが無いマシンでもそのまま実行できる。

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
| 認証画面が **Access denied**（Jira & Confluence site which you don't have ... access） | ブラウザで**別の Atlassian アカウント**にログインしている。先に `https://hinac.atlassian.net` が開けるアカウントでログインし直してから Authenticate する |
| `claude` 起動時に Claude のログインを求められる | ターミナルの `claude` はデスクトップアプリとログインが別。**開いたブラウザで入っているアカウントを確認**してから進める（Apple でサインインすると別アカウントが黙って作られる） |
| `Accessing workspace: /Users/<名前>` の信頼確認 | ホームで起動している。**No, exit** を選び、リポジトリのフォルダで `claude` を起動し直す |
| デスクトップアプリで `✔ Connected` なのに atlassian のツールが無い | セッションを開き直す（起動時にしか読み込まれない） |
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

> ⚠️ **Xcode は iPhone の iOS より新しいものが要る。** 端末の iOS に対応する
> Developer Disk Image を Xcode が持っていないと、実機で動かせない。
> 症状は `The developer disk image could not be mounted on this device.`。
> このときは Xcode を更新する。
>
> **`~/Library/Developer/Xcode/iOS DeviceSupport` の中身で判断しないこと。**
> あそこはクラッシュログを読むためのシンボルキャッシュで、別物。
> 端末のiOS版が入っていなくても動くし、入っていても動かないことがある
> （2026-09-19 に実際に誤判断した）。判断材料はエラーメッセージの方。

### 6.1 Apple ID を登録する

**Xcode → Settings → Accounts** で Apple ID を追加する。

**Apple Developer Program は加入済み**（2026-09-13 支払い、2026-09-16 承認。有効期限 2027-09-16）。
署名に使うのは **Team ID `7GV9WUC8NP`**。

> ⚠️ **同じ Apple ID に勤務先の Developer チームが同居している。**
> Apple のポータルは既定で勤務先チームを選んだ状態で開くことがある。
> 証明書・App ID・プロファイルを触る前に、**個人チームが選ばれているか毎回確認する。**
> 取り違えると勤務先のチームに証明書を作ってしまう。

有料加入しても **Team ID は無料時代から変わらない**。
「Personal Team」表記が Xcode のキャッシュに残ることがあるが、ビルドの実体には影響しない。

### 6.2 ビルド時に出るパスワード要求について

初回ビルド時に **「codesign wants to access key ... in your keychain」** というダイアログが出る。

> ⚠️ 求められているのは **Macのログインパスワード**。Apple ID のパスワードではない。

**「Always Allow」** を選ぶ（「Allow」だとビルドのたびに聞かれる）。

### 6.3 有料チームで署名できているかの確認

**「ビルドが通った」は有料化の証明にならない。** 加入前に作られた無料の
プロファイルがキャッシュに残っていると、それを使い回してビルドが成功してしまう
（2026-09-19 に実際に起きた）。

判定は**発行されたプロファイルの有効期限**で行う。**無料は7日、有料は1年。**

```bash
P=$(ls "$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles"/*.mobileprovision | head -1)
security cms -D -i "$P" > /tmp/pp.plist
/usr/libexec/PlistBuddy -c "Print :Name" -c "Print :ExpirationDate" /tmp/pp.plist
```

7日後の日付が出たら無料のものを掴んでいる。キャッシュを退避して取り直す:

```bash
mkdir -p /tmp/pp-backup
mv "$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles"/*.mobileprovision /tmp/pp-backup/
xcodebuild -project HinaBlocks/HinaBlocks.xcodeproj -scheme HinaBlocks \
  -destination 'generic/platform=iOS' -allowProvisioningUpdates build
```

エンタイトルメントが実際に焼き込まれているかは、署名後のアプリを見る:

```bash
codesign -d --entitlements - --xml <ビルドされた .app> | plutil -p - | grep family-controls
```

Xcode の "Automatically manage signing" は将来 fastlane match に移行予定（WBS 3.3）。

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

### 6.5 テストの実行

**シミュレータでは Family Controls が動かない。テストは実機で走らせる。**

```bash
xcodebuild -project HinaBlocks/HinaBlocks.xcodeproj -scheme HinaBlocks \
  -destination 'id=<端末のUDID>' -allowProvisioningUpdates test
```

UDID は `xcrun devicectl list devices` で確認する。

> ⚠️ **実機テスト中は端末のロックを解除しておくこと。** ロック状態でエラーが変わる:
> - ロック中: `Lost pending connection to the test runner before launch.`
> - 解除済みで失敗: `Timed out while enabling automation mode.`
>   → iPhone の「設定 → デベロッパ」で UI オートメーションを確認する

Xcode を大きく更新すると**シミュレータのランタイムが消えていることがある**。
実機で走らせるなら困らないので、数GBのダウンロードを慌てて始めなくてよい。

### SwiftLint（WBS 1.5）

```bash
brew install swiftlint
scripts/lint.sh
```

指摘が0件なら何も表示されない。CI と同じ厳しさで見るときは `scripts/lint.sh --strict`。

## 7. コミット前の必須チェック

公開リポジトリのため、**実名・個人サイト・メールアドレスの混入**を毎回確認する。

**マシンごとに初回のみ**: チェックしたい語を1行ずつ書いたファイルをローカルに作る。
`.gitignore` 対象なので **git では運ばれない。2台目でも必ず作り直す。**

実名を手で打つとシェル履歴やログに残るため、macOSアカウント情報から生成する:

```bash
{ id -F; id -un; } | sed '/^$/d' | sort -u > .private-patterns
```

住所・電話番号・旧ハンドル・個人サイトのドメインなど、他に隠したい語があれば
エディタで追記する:

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

> ⚠️ **このファイルが無いまま運用しない。**
> `grep -f` は対象ファイルが無いとエラーになるだけなので、代わりに
> 検索語をコマンドへ直接書きたくなる。だがそれをやると**実名がシェル履歴・
> 端末ログ・セッションの記録に残る**。手順書が避けようとしているのと同じ失敗。
> 2026-09-27 時点で、実際にこの代用が繰り返されていたことが判明した。

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
