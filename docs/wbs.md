# WBS v1.3 - Freedom系アプリ開発 & 発信プロジェクト

**運用憲法: すべての作業はこのWBSのチケットに紐づく。WBSにない作業は、先にWBSに追加してから着手する。**

見積もり時間は「1人・AIアシスト前提」の目安。
レーン: [DEV]=開発 / [CONTENT]=発信 / [CHARA]=キャラ運用
ステータス: ✅=完了 / 🔄=着手中 / （無印）=未着手

変更履歴:
- v1.0: 初版
- v1.1: キャラ決定（丸の内ヒナ）を反映、0.4系を完了化、0.4.4/0.5.1を追加
- v1.2: 全レーンをClaude Codeに集約する構成変更。0.7（Atlassian MCP設定）を追加、character.md作成を0.4.5として追加
- v1.3: キャラ名を「丸ノ内ひな」→「丸の内ヒナ🐣」に変更。0.4.3（アイコン画像）完了により0.4を完了化。0.8（ドキュメント整合性の整理）を追加

---

## Phase 0: 企画・アーキテクチャ定義（合計 ~12h）

- 0.1 [DEV] MVP要件定義（2h）✅
  - 0.1.1 ✅ ブロック対象の決定 → アプリのみ（Safariサイトは含めない）
  - 0.1.2 ✅ スケジュール仕様の決定 → 手動オンオフ（時間帯/ポモドーロは後Phase）
  - 0.1.3 ✅ MVPに入れない機能リストの明文化（統計/パスワード/複数プロファイル/iCloud同期等）
  - → 成果物: docs/requirements.md v1.0
- 0.2 [DEV] Confluence要件定義ページ作成（2h）✅
  - Confluence有効化（無料プラン）→ `/mcp` 再認証でConfluenceスコープ追加 → SDスペースにページ作成
  - ページ: https://hinac.atlassian.net/wiki/spaces/SD/pages/65986 （原本 docs/requirements.md と同期）
- 0.3 [DEV] Jiraプロジェクト作成・3レーンEpic設計（1.5h）🔄
  - 0.3.1 ✅ DEV/CONTENT/CHARAのEpic作成 → KAN-1(DEV)/KAN-2(CONTENT)/KAN-3(CHARA)
  - 0.3.2 ✅ ワークフロー確認（To Do → In Progress → In Review → Done。KANに標準装備済み）
  - 0.3.3 🔄 Phase 0-1をチケット化（KAN-4〜18）。完了分はDone、着手中はIn Progressへ反映済み。Phase 2以降は運用が回り始めてから追加
  - ✅ CLAUDE.mdのチケット番号例を実態に修正（`PROJ-XXX` → `KAN-XXX`）。プロジェクトキー `KAN` はJiraのカンバンテンプレート既定値だが、リネームせず維持する判断（2026-07-26）
- 0.4 [CHARA] キャラ設定（3h）✅
  - 0.4.1 ✅ 名前・口調・性格の決定 →「丸の内ヒナ」/ 清楚系OL・詰まると素が出る / AIくん呼び
  - 0.4.2 ✅ ビジュアル方向性の決定 → リアル寄りAI生成（実在人物参照なし・AI生成明記）
  - 0.4.3 ✅ アイコン画像の作成 → ChatGPTで生成、表情差分4種を `content/assets/hina/` に格納
  - 0.4.4 ✅ 初期10投稿の台本作成
  - 0.4.5 ✅ docs/character.md（キャラバイブル）作成
- 0.5 [CHARA] Xアカウント開設・プロフィール設計（1.5h）✅
  - 0.5.1 ✅ プロフィール文の決定（@hina_tsukuru・表示名「ひな🐣」）
  - 0.5.2 ✅ アカウント設定・アイコン/ヘッダー設定・投稿0を固定ポスト化（2026-07-25）
    - 旧投稿2件（「バンクリ〜」「Xの設定〜」）はそのまま残す判断（2026-07-25。急ぎで消す必要なしとユーザー判断）
- 0.6 [CONTENT] 連載第1回記事「計画編」執筆・公開（2h）✅
  - 執筆 ✅ → `content/articles/01-keikaku-hen.md`（原本）
  - 公開 ✅ → https://zenn.dev/hinac/articles/32cdce0707fb9c （2026-07-24）
  - Zennアカウント: @hinac / 表示名 hina🐣 / Googleログインで作成
- 0.7 [DEV] Atlassian MCP設定（Jira/ConfluenceをClaude Codeに接続）（1.5h）🔄
  - サイト: https://hinac.atlassian.net / cloudId: f1ce1616-29e0-4d64-a17b-0e7dc4dadeb0
  - Jiraプロジェクト: KAN（id 10001・名前「hina」・team-managed）を使用。SAM1はサンプルなので無視
  - ⚠️ 課題A: 現在のOAuth権限は jira-work のみ。**Confluenceのスコープが無く 0.2 は今のままだと不可**。`/mcp` で再認証してConfluence権限を足すか、0.2をブラウザ操作で行うか要判断
  - ⚠️ 課題B: SSE接続方式は2026/6/30廃止済み（今は動作）。将来 `https://mcp.atlassian.com/v1/mcp`（Streamable HTTP）へ移行が必要 → 1.x系で「0.10 MCP接続方式の移行」として対応
  - 0.7.1 ✅ 1台目MacでMCPセットアップ・接続確認（2026-07-24。user configで✔ Connected）
    - ⚠️ 罠: 最初 `~` で `claude mcp add`（-sなし）したため local スコープが `~` に紐づき、プロジェクトから見えなかった
    - 正しいコマンド: `claude mcp add -s user --transport sse atlassian https://mcp.atlassian.com/v1/sse`（**-s user 必須**。全プロジェクト・両Mac共通で使える）
    - 認証は `/mcp` → Authenticate → ブラウザで許可 → ✔ Connected
  - 0.7.2 2台目MacでMCPセットアップ・接続確認（未。上の -s user 付きコマンドで実施）
- 0.9 [CHARA] 各サービスのハンドル統一を検討（0.5h）✅ 方針決定（2026-07-25）
  - 現状: X=@hina_tsukuru / Zenn=@hinac / GitHub=これから作成
  - **決定: GitHubはヒナ名義で新規アカウントを取得する**（実名アカウントは使わない）
    - 理由: 記事で「GitHub：実際のコード（隠さず公開）」と宣言済み。3層構造（X/Zenn/GitHub）の一角として公開前提のため、実名コミットは匿名運用が崩れる
    - コミットのauthor名・メールはGitHub上で永久公開され、**push後の取り消しは実質不可能**
    - メールは GitHub の非公開メール（`<username>@users.noreply.github.com`）を使う
    - git設定はリポジトリ限定（`git config user.email`）で行い、他プロジェクトの実名設定に影響させない
  - ハンドルの完全統一は断念。Zennの `@hinac` は変更が面倒なため、相互リンクで繋ぐ運用とする
- 0.8 [DEV] ドキュメント整合性の整理（0.5h）✅
  - docs/ 配下とCLAUDE.mdのキャラ名・ファイル一覧・ステータス表記を統一
  - 進捗ステータスの正はwbs.mdのみとし、agenda.mdからは重複を排除

## Phase 1: 環境・リポジトリ構築（合計 ~10h）

- 1.1 [DEV] Apple Developer Program登録（0.5h + 承認待ち）⏸ **保留**（2026-07-25判断）
  - 判断: 年12,800円の課金は「実際に必要になるまで」遅らせる。無料Apple IDの署名で先に進む
  - 無料署名でできること: Xcodeプロジェクト作成・空アプリの実機起動（= 1.4は無料で完走可能）
  - 無料署名の制約: 署名が**7日で失効**するため週1でXcodeから入れ直しが必要
  - ⚠️ 未確認: FamilyControlsは制限付きエンタイトルメントのため、**2.1以降で有料メンバーシップが必要になる可能性が高い**（Apple公式ドキュメントからは確証取れず）
  - 確認方法: Xcodeで Family Controls capability を追加しようとした時点で可否が判明する（1.4.2）。**課金前に答えが出るので、そこで判断する**
- 1.2 [DEV] GitHubリポジトリ作成・初期設定（2h）🔄
  - リポジトリ: https://github.com/hina-tsukuru/hina-blocks （Public・2026-07-25）
  - 1.2.1 🔄 リポジトリ作成 ✅ / **main保護設定は未実施**
  - 1.2.2 ✅ .gitignore（Xcode・fastlane・.DS_Store対応）、README作成
  - 1.2.3 PRテンプレート作成（詰まった点/ネタ度欄つき）
  - ⚠️ 詰まった点（記事ネタ）: CLAUDE.mdに実名個人サイトのドメインが書かれており、
    公開すると「ヒナ名義リポジトリ → 実名サイト」の導線ができる状態だった。
    push前のgrepで発見 → 該当箇所を一般化 → **さらに履歴にも残っていたため未push状態を利用して履歴を再構築**。
    再発防止: push前に実名・個人サイト・メールの混入をgrepで確認する
  - コミット名義: `hina-tsukuru` + GitHub非公開メール（`git config` はリポジトリ限定で設定）
- 1.3 [DEV] CLAUDE.md作成（1h）
- 1.4 [DEV] Xcodeプロジェクト作成・実機ビルド確認（2h）
  - 1.4.1 プロジェクト作成（SwiftUI）
  - 1.4.2 Family Controls capability追加
  - 1.4.3 手元のiPhoneで空アプリが起動するまで
- 1.5 [DEV] SwiftLint導入（1h）
- 1.6 [DEV] 2台目Macのセットアップ・同期確認（1.5h）
- 1.7 [CONTENT] 週次発信の初回実施（環境構築ネタでX投稿3-5本）（1h）
- 1.8 [CONTENT] 記事第2回「環境構築編」執筆・公開（1h ※PRメモから生成）

## Phase 2: MVP実装（合計 ~20h）

- 2.1 [DEV] FamilyControls: 許可リクエスト実装（3h）
- 2.2 [DEV] FamilyActivityPicker: ブロック対象選択UI（3h)
- 2.3 [DEV] ManagedSettings: シールド適用/解除（4h）
- 2.4 [DEV] DeviceActivity: スケジュール機能（5h）
- 2.5 [DEV] メイン画面UI（SwiftUI）（3h）
- 2.6 [DEV] 実機での結合動作確認・録画（2h）
- 2.7 [CONTENT] 記事第3回「Screen Time API実装編」（2h）
- 2.8 [CONTENT] 週次発信 x 実装期間分（各1h）

## Phase 3: CI/CD構築（合計 ~12h）

- 3.1 [DEV] GitHub Actions: ビルドworkflow（2h）
- 3.2 [DEV] GitHub Actions: テスト実行追加（1.5h）
- 3.3 [DEV] fastlane導入・match証明書管理（4h）
  - 3.3.1 fastlane init、証明書用プライベートリポジトリ作成
  - 3.3.2 match設定、両Macで証明書取得確認
- 3.4 [DEV] TestFlightアップロードLane作成（2.5h）
- 3.5 [DEV] Conventional Commits/CHANGELOG運用開始（0.5h）
- 3.6 [CONTENT] 記事第4回「CI/CD編（Jenkins経験者の視点）」（1.5h）

## Phase 4: 自分専用運用（合計 ~8h + 2週間の利用期間）

- 4.1 [DEV] 2週間のドッグフーディング（利用自体は0h）
- 4.2 [DEV] フィードバックのJiraチケット化（1h）
- 4.3 [DEV] 改善サイクル1周（バグ修正・UX改善）（5h）
- 4.4 [CONTENT] 記事第5回「使ってみた編」（2h）

## Phase 5: 配布判断（合計 ~8h + 審査待ち）

- 5.1 [DEV] プライバシーポリシーページ作成（GitHub Pages）（1.5h）
- 5.2 [DEV] Family Controls配布用エンタイトルメント申請（1h + 待ち）
- 5.3 [DEV] App Store Connect準備（スクショ・説明文）（3h）
- 5.4 [CHARA] ストア素材にキャラ活用（アイコン・スクショ装飾）（1.5h）
- 5.5 [CONTENT] 記事第6回「申請編」（1h）

## Phase 6: 振り返り（合計 ~4h）

- 6.1 [CONTENT] 総括記事「全Phase振り返り」（2.5h）
- 6.2 [DEV] リポジトリのREADME最終整備（1h）
- 6.3 [CHARA] キャラアカウントでの完結報告・お礼投稿（0.5h）

---

**総計: 約74h**（+ 待ち時間、ドッグフーディング期間）

---

# デイリータスクへの落とし込みルール

## 基本の型

1. **WBSの葉ノード（x.x.x）をそのままJiraのSub-taskにする** — 上の番号がチケット番号に対応する状態を作る
2. **1日の作業単位は「2h以内のチケット1〜2枚」** — 平日夜なら1枚、休日なら2〜4枚
3. **金曜または日曜の週次レビュー（30分）で翌週分を選ぶ** — Jiraのスプリント機能で「今週スプリント」に5〜7枚だけ入れる。それ以外は見ない
4. **着手ルール**: その日やるチケットを朝（または前夜）に1枚だけIn Progressにする。マルチタスク禁止

## ペース試算

- 平日2日 x 1.5h + 週末3h = **週6h**ペース → 全体74hで**約3ヶ月**
- 平日3日 x 1.5h + 週末5h = **週9.5h**ペース → **約2ヶ月**

## 週次サイクル（固定ルーチン）

| 曜日 | やること |
|---|---|
| 月〜木 | デイリータスク消化（DEV中心） |
| 金 or 土 | 週1発信タイム（30分〜1h、CONTENT消化） |
| 日 | 週次レビュー30分: 完了確認 → 翌週のスプリント選定 → WBSズレ修正 |

## AIの使い所

- デイリー: Claude Codeにチケット単位で実装を依頼（1チケット=1ブランチ=1PR）
- 週次: このチャットにPRメモを貼って投稿案・記事ドラフト生成
- 月次/Phase節目: WBS自体の見直し（見積もりズレの補正）をClaudeと実施
