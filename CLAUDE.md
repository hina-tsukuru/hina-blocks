# CLAUDE.md

## プロジェクト概要

iOS向け集中支援アプリ（Freedom系のアプリ/サイトブロッカー）の個人開発。
Apple Screen Time API（FamilyControls / ManagedSettings / DeviceActivity）を使用。
まず自分専用、将来的にTestFlight→App Store配布を検討。

このプロジェクトは同時に「AI駆動開発・DevOpsの学習」と「発信（ブログ/X）」を目的とした連載企画でもある。

## 運用憲法（最重要）

**すべての作業は `docs/wbs.md` のWBSチケットに紐づく。WBSにない作業は、先にWBSに追加してから着手する。**

- 作業開始時は必ず「どのWBS番号のタスクか」を確認してから着手する
- ユーザーがWBS番号なしで作業を依頼した場合、該当するWBS項目を確認するか、なければWBSへの追加を提案する
- WBS改訂時はバージョン番号を上げ、変更履歴に追記する

## ドキュメントの書き分け

**ファイル一覧は README.md に置く。ここには重複させず、「何をどこに書くか」のルールだけを持つ。**

- **進捗の正は Jira（`KAN`）**。markdownファイルに進捗を書かない（`wbs.md` も `agenda.md` も進捗を持たない）
  - 「今どこまで進んだか」を聞かれたら、推測せず **Jiraを見にいく**
  - `docs/wbs.md` が持つのは**計画**（作業の分解・見積もり）と**判断の記録**（なぜそうしたか・詰まった点・再発防止）
  - 粒度: `agenda.md`（全体像）→ `wbs.md`（作業の分解）→ Jira（今日の状態）
- **要件は `docs/requirements.md` が正**。Confluenceは同期先であって原本ではない
- **記事の原本は `content/articles/`**。Zennは現時点の公開先でしかなく、後で別サイトへ移せる形を保つ
- **発信物を作る前に必ず `docs/character.md` を読む**（口調・投稿の型・運用方針）
- **マシン固有のセットアップ手順は `docs/setup.md`**。gitで共有できない設定（MCP接続など）はここに書く
- 新しいドキュメントを追加したら、**README.md の構成表にも追記する**（一覧の正はREADME）

## 開発ルール

### ブランチ運用（GitHub Flow）
- `main` は常にビルドが通る状態を保つ。直接pushしない
- ブランチ名: `feature/KAN-XXX-short-description`（Jiraチケット番号を含める）
- 1チケット = 1ブランチ = 1PR

### コミット規約（Conventional Commits）
- `feat:` / `fix:` / `chore:` / `docs:` / `refactor:` / `test:` プレフィックス必須
- 末尾にJiraチケット番号: `feat: アプリ選択ピッカーを追加 (KAN-123)`
  - プロジェクトキーは `KAN`（Jiraのカンバンテンプレートの既定値。プロジェクト名は「hina」）

### PRルール
- PRテンプレートの「詰まった点」「ブログ化ネタ度⭐1-3」欄を必ず埋める
  - これは発信フロー（週次のX投稿・記事生成）の素材になる。省略しない
- セルフレビュー後にマージ、マージ後ブランチ削除

### バージョニング
- セマンティックバージョニング（MAJOR.MINOR.PATCH）
- `CFBundleShortVersionString` = 表示バージョン、`CFBundleVersion` = ビルド番号（fastlaneで自動インクリメント）
- TestFlightアップロードごとに `main` へ `vX.Y.Z` タグ
- `CHANGELOG.md` を Keep a Changelog 形式で更新

## 技術スタック・ツールチェーン

- **言語/UI**: Swift / SwiftUI（外部ライブラリは原則使わない。必要時はSPM + Package.resolvedをコミット）
- **主要フレームワーク**: FamilyControls（許可・ピッカー）、ManagedSettings（シールド）、DeviceActivity（スケジュール）
- **PM**: Jira（DEV / CONTENT / CHARA の3レーンEpic）、Confluence（要件・ADR）
- **CI**: GitHub Actions（macosランナー、ビルド+テスト+SwiftLint）
- **CD**: fastlane（TestFlightアップロード）、fastlane match（証明書管理、専用プライベートリポジトリ）
- **品質**: SwiftLint、GitHub CodeQL

## 環境の前提

- **Macが2台**（会社に置いてる個人Mac + 自宅Mac）。どちらからも作業する
  - 作業終了時は必ずcommit & push（未pushの変更をローカルに残さない）
  - 証明書はfastlane matchで両Mac共有。Xcodeの "Automatically manage signing" は使わない
  - `DerivedData` / `xcuserdata` 等は .gitignore 対象
  - Claude Codeのセッションはマシンローカルで引き継がれない前提。作業の文脈はPR本文とコミットメッセージに残す
- 実機テストはユーザーのiPhone。Family Controlsはシミュレータで動作しないため、ロジック部分のみXCTestで担保する
- Apple Developer Program加入済み前提（未登録ならWBS 1.1が先）

## Screen Time API実装上の注意

- FamilyControls の development entitlement で開発。配布時は別途Appleへ申請が必要（WBS 5.2）
- アプリはユーザーが選択したアプリの具体名を取得できない（不透明トークン設計）。UI設計はこれを前提にする
- ユーザーデータは一切外部送信しない設計方針（プライバシーポリシーにも明記予定）

## 発信レーン（CONTENT / CHARA）— Claude Codeが担当

このプロジェクトはDEV/CONTENT/CHARAの全レーンをClaude Codeで実行する。

- キャラ設定・口調・台本は `docs/character.md` を必ず参照する（丸の内ヒナ名義、AI生成キャラであることを明記して運用）
- 週次発信タイム: 直近1週間のマージ済みPR本文（詰まった点欄）を読み、X投稿案3〜5本と記事の書き溜めを `content/drafts/` に生成する
- 記事はPhase節目ごとに1本、`content/articles/` にmarkdownで作成 → ユーザーがZennに公開
  - **記事の原本は `content/articles/` の markdown**。公開先（Zenn）は「今の露出先」でしかなく、後でヒナ専用ブログサイトへ乗り換え可能。原本を書き直す必要はない設計にする
  - 運営者本人の実名で運用している他サイトには、ヒナ名義の記事を載せない（匿名運用が崩れるため）
- PR本文は「後で読んで意味がわかる」粒度で書く（発信の素材になるため省略しない）

## Jira / Confluence連携

- JiraとConfluenceはMCP（Atlassian Remote MCP Server）経由でClaude Codeから直接操作する
- セットアップは両方のMacで必要（WBS 0.7）。未設定の状態でJira操作を求められたら、先にセットアップを案内する
- チケット運用: 着手時にIn Progress、PRマージ時にDoneへ動かす。フィードバックや新タスクはWBS追記と同時にJiraにも起票する
- **コミットメッセージにチケット番号を書く前に、必ずJiraで起票して番号を確定させる**。番号を予想で書かない（KAN-20で実際に食い違いが起きた）

## Claude Codeへの振る舞い指示

- 実装前に対象WBS番号と完了条件を復唱してから着手する
- 大きめのタスク（3h以上見積もり）は着手前にサブタスク分解を提案する
- エラー解決時は「原因・対処・再発防止」をPR本文用に3行でまとめる
- 日本語で応答する
