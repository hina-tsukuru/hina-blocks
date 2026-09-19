# WBS v1.17 - Freedom系アプリ開発 & 発信プロジェクト

**運用憲法: すべての作業はこのWBSの項目に紐づく。WBSにない作業は、先にWBSに追加してから着手する。**

見積もり時間は「1人・AIアシスト前提」の目安。
レーン: [DEV]=開発 / [CONTENT]=発信 / [CHARA]=キャラ運用

> **このファイルは進捗を持たない。** 各項目が「今どの状態か」は Jira（`KAN`）が正。
> ここに書くのは**計画**（作業の分解・見積もり）と**判断の記録**（なぜそうしたか・詰まった点・再発防止）。
> 各項目の末尾の `→ KAN-xx` が対応するチケット。
>
> 役割分担: `agenda.md`（全体像）→ **`wbs.md`（作業の分解と判断）** → Jira（今日の状態）

変更履歴:
- v1.0: 初版
- v1.1: キャラ決定（丸の内ヒナ）を反映、0.4系を完了化、0.4.4/0.5.1を追加
- v1.2: 全レーンをClaude Codeに集約する構成変更。0.7（Atlassian MCP設定）を追加、character.md作成を0.4.5として追加
- v1.3: キャラ名を「丸ノ内ひな」→「丸の内ヒナ🐣」に変更。0.4.3（アイコン画像）完了により0.4を完了化。0.8（ドキュメント整合性の整理）を追加
- v1.4: **進捗マーク（✅/🔄）を全廃し、進捗の正をJiraに一本化**。各項目にチケットIDを紐付け。項目の並び順を修正（1.9が Phase 0 に混入していた）。1.10 を追加
- v1.5: 0.10（市場調査）の結論を iOS 26.4 の仕様変更に合わせて訂正。0.7.2 の完了を反映。並び順を修正（0.10が0.9の前に入っていた）
- v1.6: 1.14（グロース方針とROIチェックリスト）を追加。**新規アプリは着手前にROIチェックリストを通す**方針をCLAUDE.mdに追加。あわせて0.10（市場調査）の価格モデルに関する結論を訂正（**このカテゴリは収益化できている**）
- v1.7: 1.15（匿名公開の前提整備: 屋号DeepInception・ドメインdeepinception.co・EU配信除外）を追加
- v1.8: 1.16（Bundle IDを `co.deepinception.hinablocks` に変更）を追加
- v1.9: 1.1（Apple Developer Program登録）の保留を解除（2026-09-13 支払い済み）
- v1.10: 1.17（deepinception.co のWebサイト公開）を追加
- v1.11: 1.3（CLAUDE.md の整備内容）を追記
- v1.12: 1.5（SwiftLint導入）の内容を追記
- v1.13: 1.18（deepinception.co のなりすまし対策）を追加
- v1.14: 1.16（Bundle ID変更）に有料チームでの署名検証の結果を追記。1.19（Xcode更新: 実機実行のブロッカー解消）を追加
- v1.15: 1.19 の解消を記録。あわせて1.19の「原因」に挙げていた根拠（iOS DeviceSupport フォルダの中身）が誤りだったので訂正
- v1.16: Phase 2 を起票しチケット番号を反映。2.1（許可リクエスト）の実装内容と詰まった点を追記
- v1.17: 2.2（ブロック対象の選択UI）の実装内容と詰まった点を追記

---

## Phase 0: 企画・アーキテクチャ定義（合計 ~12h）

- 0.1 [DEV] MVP要件定義（2h）→ KAN-4
  - 0.1.1 ブロック対象の決定 → **アプリのみ**（Safariサイトは含めない）
  - 0.1.2 スケジュール仕様の決定 → **手動オンオフ**（時間帯/ポモドーロは後Phase）
  - 0.1.3 MVPに入れない機能リストの明文化（統計/パスワード/複数プロファイル/iCloud同期等）
  - 成果物: `docs/requirements.md` v1.0
- 0.2 [DEV] Confluence要件定義ページ作成（2h）→ KAN-5
  - Confluence有効化（無料プラン）→ `/mcp` 再認証でConfluenceスコープ追加 → SDスペースにページ作成
  - ページ: https://hinac.atlassian.net/wiki/spaces/SD/pages/65986 （原本 `docs/requirements.md` と同期）
- 0.3 [DEV] Jiraプロジェクト作成・3レーンEpic設計（1.5h）→ KAN-6
  - 0.3.1 DEV/CONTENT/CHARAのEpic作成 → KAN-1(DEV) / KAN-2(CONTENT) / KAN-3(CHARA)
  - 0.3.2 ワークフロー確認（To Do → In Progress → In Review → Done。KANに標準装備済み）
  - 0.3.3 Phase 0-1をチケット化。Phase 2以降は運用が回り始めてから追加する
  - プロジェクトキー `KAN` はJiraのカンバンテンプレート既定値。既にpush済みコミットが参照しているためリネームせず維持する判断（2026-07-26）
- 0.4 [CHARA] キャラ設定（3h）→ KAN-8
  - 0.4.1 名前・口調・性格の決定 →「丸の内ヒナ」/ 清楚系OL・詰まると素が出る / AIくん呼び
  - 0.4.2 ビジュアル方向性の決定 → リアル寄りAI生成（実在人物参照なし）
  - 0.4.3 アイコン画像の作成 → ChatGPTで生成、表情差分4種を `content/assets/hina/` に格納
  - 0.4.4 初期10投稿の台本作成
  - 0.4.5 `docs/character.md`（キャラバイブル）作成
- 0.5 [CHARA] Xアカウント開設・プロフィール設計（1.5h）→ KAN-9
  - 0.5.1 プロフィール文の決定（@hina_tsukuru・表示名「ひな🐣」）
  - 0.5.2 アカウント設定・アイコン/ヘッダー設定・投稿0を固定ポスト化（2026-07-25）
  - 旧投稿2件（「バンクリ〜」「Xの設定〜」）はそのまま残す判断（2026-07-25）
- 0.6 [CONTENT] 連載第1回記事「計画編」執筆・公開（2h）→ KAN-10
  - 原本: `content/articles/01-keikaku-hen.md`
  - 公開: https://zenn.dev/hinac/articles/32cdce0707fb9c （2026-07-24）
  - Zennアカウント: @hinac / 表示名 hina🐣 / Googleログインで作成
- 0.7 [DEV] Atlassian MCP設定（Jira/ConfluenceをClaude Codeに接続）（1.5h）→ KAN-7
  - サイト: https://hinac.atlassian.net / cloudId: `f1ce1616-29e0-4d64-a17b-0e7dc4dadeb0`
  - Jiraプロジェクト: KAN（id 10001・名前「hina」・team-managed）。SAM1はJira初期サンプルなので無視
  - 0.7.1 1台目MacでMCPセットアップ・接続確認（2026-07-24）
  - 0.7.2 2台目MacでMCPセットアップ・接続確認（2026-07-27完了）
  - 詰まった点①: 最初 `~` で `claude mcp add`（`-s` なし）したため local スコープが `~` に紐づき、プロジェクトから見えなかった。**`-s user` が必須**
  - 詰まった点②: `claude mcp list` で ✔ Connected でも、**Claude Codeを再起動しないとツールが読み込まれない**
  - 詰まった点③: Confluenceだけ 403 `The app is not installed`。Jiraのスコープしか認証していなかったため。Confluence有効化後に `/mcp` で再認証して解決
  - 詰まった点④: 2台目では **claude CLI 自体が未インストール**だった。node v15 / Homebrew 3.0.10 と古く npm も brew も使えず、公式インストーラ（`curl -fsSL https://claude.ai/install.sh | bash`）で解決。`~/.local/bin` へのPATH追記も必要だった
  - 現行コマンド: `claude mcp add -s user --transport http atlassian https://mcp.atlassian.com/v1/mcp`
    （SSE方式は2026/6/30で廃止済みのため Streamable HTTP に移行済み）
- 0.8 [DEV] ドキュメント整合性の整理（0.5h）※チケットなし（WBS追加時に起票せず）
  - `docs/` 配下とCLAUDE.mdのキャラ名・ファイル一覧・表記を統一
  - agenda.md から進捗（チェックボックス）を排除し、二重管理を解消
- 0.9 [CHARA] 各サービスのハンドル統一を検討（0.5h）※チケットなし
  - 現状: X=@hina_tsukuru / Zenn=@hinac / GitHub=hina-tsukuru
  - **決定: GitHubはヒナ名義で新規アカウントを取得**（実名アカウントは使わない）
    - 理由: 記事で「GitHub：実際のコード（隠さず公開）」と宣言済み。公開前提のため実名コミットは匿名運用が崩れる
    - コミットのauthor名・メールはGitHub上で永久公開され、**push後の取り消しは実質不可能**
    - メールは GitHub の非公開メール（`<ID>+<username>@users.noreply.github.com`）を使う
    - `git config` はリポジトリ限定で設定し、他プロジェクトの実名設定に影響させない
  - ハンドルの完全統一は断念。Zennの `@hinac` は変更が面倒なため、相互リンクで繋ぐ運用とする
- 0.10 [DEV] 競合・市場調査（0.5h）→ KAN-23
  - 目的: Apple Developer Program（年12,800円）を払うかの投資判断材料
  - 成果物: `docs/market-research.md`（調査日 2026-07-28。価格は変動するため再確認前提）
  - 結論①: **完全無料のアプリが存在する**（ScreenZen。サブスク・課金なしで全機能開放）
  - 結論②: それでも有料アプリが成立するのは、**iOS標準スクリーンタイムに「Ignore Limit」ボタンという穴がある**ため。有料アプリはそこを潰すことを売っている
  - 結論③: サードパーティ側にあった「設定から権限をトグルでオフにできる」穴は **iOS 26.4 で塞がれた**（パスコードが必須になった）
    - ⚠️ 初回調査では「原理的に完全なロックは作れない」と結論づけたが**これは誤りだった**。参照した情報が iOS 18 時代のもので、実機を見たユーザーの指摘で判明した
    - **再発防止: API・OSの制約を調べるときは情報の日付を必ず確認する**
  - 結論④: ただし**自分用だと自分がパスコードを知っている**。このジャンルの本質は「ロック」ではなく、**破るコストを衝動が続く時間より長くするコミットメント装置**の設計にある（衝動は数分で過ぎるため、数分耐えられれば足りる）
  - 判断への影響: 収益化は期待しない方がよい。12,800円は事業投資ではなく**学習と発信のコスト**として評価する
  - 差別化の余地: 機能では勝てない（AppBlock 1,500万ユーザー・ScreenZen無料）が、**「知っていても効く仕掛け」を丁寧に作るアプリは少ない**。特に**解除の時間差**は実装が軽く効果が大きい
  - **MVP設計への示唆**: 現在の要件は「ボタンで手動オンオフ」で、自分でいつでも解除できるため弱い。ただし**設計を先に変えるのではなく、Phase 4 で「実際に自分が即解除するか」を観測する方が価値が高い**。「作った当日に自分で解除した」なら、それは失敗ではなく最良の観測結果であり記事ネタでもある

## Phase 1: 環境・リポジトリ構築（合計 ~10h）

- 1.1 [DEV] Apple Developer Program登録（0.5h + 承認待ち）→ KAN-19（2026-09-13 に保留を解除して支払い済み。承認待ち）
  - 判断（2026-07-25）: 年12,800円の課金は「実際に必要になるまで」遅らせ、無料Apple IDの署名で先に進む
  - 無料署名でできること: Xcodeプロジェクト作成・空アプリの実機起動（= 1.4は無料で完走可能）
  - 無料署名の制約: 署名が**7日で失効**するため週1でXcodeから入れ直しが必要
  - 未確認: FamilyControlsは制限付きエンタイトルメントのため、**2.1以降で有料メンバーシップが必要になる可能性が高い**（Apple公式ドキュメントからは確証取れず）
  - 確認方法: Xcodeで Family Controls capability を追加した時点（1.4.2）で可否が判明する。**課金前に答えが出る**
  - 課金する場合の論点: 実名・実在住所での登録が必須。App Store公開時（Phase 5）に販売者名として実名が公開されるため、ヒナの匿名運用との兼ね合いをPhase 5で判断する
- 1.2 [DEV] GitHubリポジトリ作成・初期設定（2h）→ KAN-12
  - リポジトリ: https://github.com/hina-tsukuru/hina-blocks （Public・2026-07-25）
  - 1.2.1 リポジトリ作成・main保護設定
    - PR必須 / 承認数0（1人開発のため。CLAUDE.mdの「セルフレビュー後にマージ」に対応）
    - **管理者にも適用**（オフにすると自分だけ素通りでき、保護の意味が無くなる）
    - force push・ブランチ削除は禁止
  - 1.2.2 `.gitignore`（Xcode・fastlane・.DS_Store対応）、README作成
  - 1.2.3 PRテンプレート作成（詰まった点は原因/対処/再発防止の3行構成・ネタ度⭐1-3）
  - 詰まった点①（⭐3）: CLAUDE.mdに実名で運用している個人サイトのドメインが書かれており、公開すると「ヒナ名義リポジトリ → 実名サイト」の導線ができる状態だった。**匿名を守るために書いたルール自体が匿名を破る**構造。push前のgrepで発見 → 一般化 → **さらにgit履歴にも残っていたため、未push状態を利用して履歴を再構築**
    - 再発防止: push前に実名・個人サイト・メールの混入をgrepで確認する（PRテンプレートの確認事項に組み込み済み）
  - 詰まった点②（⭐3）: 1人開発のブランチ保護は素直に設定すると壊れる。「管理者にも適用」をオフにすると所有者＝作業者なので**保護が完全に無意味**になり、承認必須（1人以上）にすると自分のPRを自分で承認できず**永久にマージできなくなる**
  - コミット名義: `hina-tsukuru` + GitHub非公開メール
- 1.3 [DEV] CLAUDE.md作成（1h）→ KAN-13
  - 実体は既に存在。内容の最終整備が残っている
  - 2026-09-15 整備:
    - 「公開名義と匿名運用」の節を追加（屋号・ドメイン・連絡先・サイト・Bundle ID を固定値として1か所にまとめた。1.15〜1.17 の決定の要約）
    - 実態とずれていた記述を修正
      - 「Automatically manage signing は使わない」→ fastlane match（Phase 3）までは自動署名を使う
      - 「Apple Developer Program加入済み前提」→ Family Controls に有料加入が必要という事実と、状況の見る場所（KAN-19）
      - 「AI生成キャラであることを明記して運用」→ `character.md` の決定（2026-07-21 に明記しない方針へ変更）と矛盾していたので、`character.md` を正とする書き方に変更
    - ブラウザ操作の線引きを追加（ログイン・決済・本人確認・CAPTCHA はユーザー／Playwright のスナップショットに個人情報が残る／裏タブで描画が止まる／タブの上書き）
    - 詰まった点: **同じ決定が CLAUDE.md と character.md の2か所にあり、片方だけ古いまま**だった。このリポジトリで繰り返し起きている「2か所に書くと片方が腐る」パターン
- 1.4 [DEV] Xcodeプロジェクト作成・実機ビルド確認（2h）→ KAN-14
  - 1.4.1 プロジェクト作成（SwiftUI / XCTest / Storage=None）
    - Bundle Identifier: `io.github.hina-tsukuru.HinaBlocks`（→ 1.16 で `co.deepinception.hinablocks` に変更）
      - 組織IDは全アプリで使い回す部分。GitHubアカウントを名前空間に使う（ドメイン購入不要・匿名を維持できる）
      - 実名でアプリを作る場合は**別の名前空間**を使う。同じ名前空間に混ぜると匿名運用が崩れる
      - App Store公開後は変更不可のため、名義はプロジェクト作成時に決める
    - 署名は無料Apple ID（Personal Team）。`DEVELOPMENT_TEAM` は不透明IDなので実名は含まれない
  - 1.4.2 Family Controls capability追加 → **無料アカウントでは追加できないことを確認**（2026-07-28）
    - Capability一覧はアルファベット順だが、`Fall Detection Notifications` の次が `Game Center` で、
      **`Family Controls` が存在しない**。検索で出ないのではなく選択肢自体が提供されていない
    - → **Phase 2 に進むには Apple Developer Program（年12,800円）が必須**。1.1 の保留を解除する判断が必要（→ 2026-09-13 解除。理由は 1.14「12,800円は実績を作る参加費」）
    - 「払う前に要否を確定させる」という 1.1 の作戦は機能した（課金せずに答えが出た）
    - 前提として **対応プラットフォームを iOS のみに絞る必要があった**（下記）
  - 対応プラットフォームの絞り込み: Xcode 26 の新規プロジェクトは既定で
    `iphoneos iphonesimulator macosx xros xrsimulator` と macOS / visionOS も対象になる。
    Signing & Capabilities はプラットフォームごとにセクションが分かれるため、
    **macOSのセクションを見ている間は iOS 専用の capability が一覧に出ない**
    - General → Supported Destinations から Mac / Apple Vision を削除して iPhone のみに
    - テストターゲット側にも古い設定が残るため、全ターゲットで揃えた
    - Screen Time API は iOS 専用なので、絞り込みは要件的にも正しい
  - 1.4.3 手元のiPhoneで空アプリが起動するまで → **達成**（2026-07-29 / iPhone 16 / 無料署名）
    - 実機は `xcrun devicectl` で操作できる（Xcode GUIを使わずCLIで完結した）
      - 一覧: `xcrun devicectl list devices`
      - ビルド: `xcodebuild -destination 'id=<デバイスID>' -allowProvisioningUpdates -allowProvisioningDeviceRegistration build`
      - 導入: `xcrun devicectl device install app --device <ID> <path/to/.app>`
      - 起動: `xcrun devicectl device process launch --device <ID> <bundle-id>`
    - **関門が4段階あった**（いずれもセキュリティのための摩擦。どれか1つ欠けても動かない）
      1. **ペアリング** — iPhone側の「このコンピュータを信頼」だけでは不十分。
         `unpaired` エラーが出続ける
      2. **デベロッパモード** — iOS 16以降必須。設定 → プライバシーとセキュリティ →
         デベロッパモード。**iPhoneの再起動が必要**。しかも一度Xcodeから接続を試みるまで
         項目自体が表示されない
      3. **デバイスがプロビジョニングプロファイル未登録** — 初回は必ず弾かれる。
         `-allowProvisioningDeviceRegistration` を付けると自動登録される
      4. **プロファイルが未信頼** — インストールは成功するが起動が拒否される。
         iPhone: 設定 → 一般 → VPNとデバイス管理 → Apple ID → 信頼
    - 記事ネタ: 4段階すべてが「危険な操作の前に一手間を挟む」設計であり、
      市場調査で学んだ「摩擦の設計」と同じ構造をしている
  - 詰まった点①（⭐3）: **Xcodeが生成した全Swiftファイルのヘッダーに実名が入っていた**
    （`// Created by <実名> on ...`）。macOSアカウントのフルネームが自動で埋め込まれる仕様。
    公開リポジトリなので、そのままpushすると1.2と同じ実名漏えいになるところだった
    - 対処: 5ファイルのヘッダーを置換 + `IDETemplateMacros.plist` を `xcshareddata` に配置して、
      **今後生成されるファイルにも実名が入らないよう固定**（`xcshareddata` はgit管理されるので2台目Macでも有効）
    - 再発防止: プロジェクト生成直後、コミット前に必ず実名をgrepする
  - 詰まった点②: `git status` の `AM` は「ステージ済みの内容と現在のファイルが違う」の意味。
    実名を消す**前**の版がステージされていたため、そのままcommitすると実名が入る状態だった
    - 再発防止: **grepは作業ファイルではなく `git diff --cached`（ステージ内容）に対して行う**。
      コミットされるのはステージされた内容であって、手元のファイルではない
- 1.5 [DEV] SwiftLint導入（1h）→ KAN-15
  - 2026-09-15: Homebrew で SwiftLint 0.65.1 を導入。設定は `.swiftlint.yml`、実行は `scripts/lint.sh`
    - 既定ルールに加え、クラッシュの原因になりやすい書き方（強制アンラップ `!` など）を警告にした
    - 行の長さは 140 文字で警告
  - 初回の指摘は2件（どちらも Xcode のテンプレートのコード）→ 修正して `--strict` で0件
    - `final class` の中の `override class var` → `override static var`
    - 182文字のコメント行を折り返し
  - **Xcode のビルド時に自動で走らせる設定（Run Script）は入れていない**
    - 新しい Xcode のプロジェクトは `ENABLE_USER_SCRIPT_SANDBOXING = YES` で、ビルド中のスクリプトからソースを読めず SwiftLint が失敗するため
    - 代わりに Phase 3 の CI（GitHub Actions）で `scripts/lint.sh --strict` を実行する
  - 確認: `scripts/lint.sh --strict` 終了コード0、テストターゲット込みのビルド（build-for-testing）成功
- 1.6 [DEV] 2台目Macのセットアップ・同期確認（1.5h）→ KAN-16
  - 手順は `docs/setup.md` に整備済み。0.7.2（2台目のMCP設定）もここに含む
- 1.7 [CONTENT] 週次発信の初回実施（環境構築ネタでX投稿3-5本）（1h）→ KAN-17
  - 成果物: `content/drafts/2026-08-07-x-posts-phase1.md`（投稿案5本）
  - **A（記事告知）は投稿済み**（2026-08-07）。残り4本は分散投稿用
  - 投稿順の設計: A（告知）→ **C（AIくんが古い情報で断言した話）** → B（デベロッパモード）→ E（市場調査）→ D（実名漏れ）
    - Cを2番目に置いたのは、連載のテーマ（AI駆動開発）の核であり**単体でも成立する**ため。
      記事を読んでいない層にも届く
  - 記事公開時にZennの設定が抜けていたのを修正（トピック5つ・カテゴリーTech・絵文字🚧）
    - **カテゴリーが Idea になっていた**。技術検証の記事なので Tech が正しい
    - `ios` `xcode` が無いとiOS開発者のトピックフィードに載らないため、集客上の実害があった
- 1.8 [CONTENT] 記事第2回「環境構築編」執筆・公開（1h ※PRメモから生成）→ KAN-18
- 1.9 [DEV] ブランチ保護設定のスクリプト化（0.5h）→ KAN-20
  - `scripts/setup-branch-protection.sh`。GitHubの設定はGUIで変えてもgitに履歴が残らないため、再現可能な形でコード化した（IaCの簡易版）
  - 設定の「なぜこの値か」をスクリプト内コメントに残すのが主目的。リポジトリ作り直し時の復元手段も兼ねる → `docs/setup.md` から参照
  - 詰まった点: jqで日本語をキーに使う場合はクォートが必要（`{PR必須: ...}` は構文エラー、`{"PR必須": ...}` が正）。**書いて終わりにせず実行したことで発見**
  - Terraform本体は個人開発の規模では過剰と判断し不採用
- 1.10 [DEV] ドキュメント階層の整理（0.5h）→ KAN-21
  - WBSとJiraで進捗が二重管理になり、実際にズレていた（0.5の状態不一致・1.1のチケット重複）
  - 対応: **進捗の正をJiraに一本化**し、WBSからは進捗マークを全廃。各項目にチケットIDを紐付け
  - 詰まった点: コミットに `(KAN-20)` と書いたが**その時点でチケットが存在しなかった**。後から別作業で起票したチケットがその番号を取り、参照先が食い違った
    - 再発防止: **コミットにチケット番号を書く前に、必ずJiraで起票して番号を確定させる**。番号を予想で書かない
- 1.11 [DEV] Jiraチケット操作の担当をルール化（0.2h）→ KAN-22
  - 「誰がチケットを動かすか」が曖昧で、ユーザーが自分で管理したいと表明した後もClaudeが動かし続けていた
  - **決定: 作業した方が動かす**（Claudeが実装/ドキュメント → Claude、ユーザーがGUI操作/記事公開 → ユーザー）
  - 詰まった点: 会話で決めた取り決めが数ターンで実質無効になっていた。
    **Claude Codeのセッションは引き継がれないため、ファイルに書かれていないルールは存在しないのと同じ**
    - 再発防止: 運用上の取り決めは会話で終わらせず、その場で CLAUDE.md に落とす
  - ※ この項目自体、チケットは作ったのにWBSへの追記を忘れていた（1.12で気づいて追加）
- 1.12 [DEV] setup.mdのパス修正（0.2h）→ KAN-24
  - `docs/setup.md` の clone 手順が `cd ~/dev` だったが、そのフォルダは存在しない。
    実際の配置は `~/AI/hina-blocks`
  - **手順書の1行目で止まるため、新しいマシンでのセットアップが不可能な状態だった**
  - 対応: `mkdir -p ~/AI && cd ~/AI` に修正（フォルダが無いマシンでもそのまま実行できる）
  - 詰まった点: リポジトリを移動させたが、**それを参照している手順書を直していなかった**。
    セッションのcwdが `~/AI` になっていたことから発覚
    - 再発防止: パスを変更したら `grep -rn "<旧パス>"` で参照元を洗う
- 1.13 [DEV] git-policy.json をリポジトリで管理する（0.2h）→ KAN-25
  - `.claude/git-policy.json` が未追跡のまま置かれていた。`git-flow` スキルが読む設定ファイル
  - 内容は現行のCLAUDE.mdのルールと一致（Jiraチケット必須 / `feature/<TICKET>-<slug>` /
    PR必須 / Conventional Commits・日本語 / **`directCommitToMain: false`**）
  - 追跡する理由:
    - **2台目Macでも同じルールが効く**（未追跡だとこのMacだけ）
    - CLAUDE.mdに文章で書いたルールを**機械が読める形にしたもの**。二重管理ではなく補完関係。
      文章のルールはClaudeが読み飛ばせるが、設定ファイルは仕組みが強制する
    - `directCommitToMain: false` は、**実際に2回発生した「mainへの直接コミット」**を止める
  - あわせて CLAUDE.md に「**未マージのPRを2本以上同時に作らない**」を追加
    - 理由: 同日に2本のPRが同時に開いて `wbs.md` でコンフリクト寸前になり、
      さらにPR本文と差分が食い違うミスも起きた。「1チケット=1ブランチ=1PR」は
      書いてあったが「**一度に1本**」は書いていなかった

- 1.14 [DEV] グロース方針の策定とROIチェックリストの標準化（1h）→ KAN-26
  - 「このアプリをどう広めるか」を決めないまま Phase 2 に入ろうとしていた
  - 決定1: **ユーザーを増やす目的は「実績・信頼」**。収益ではない
    - 無料で完成度の高い競合（ScreenZen / AppBlock 1,500万ユーザー）がいる以上、収益は狙わない
  - 決定2: **記事の読者（作り手）とアプリの利用者（消費者）は別人。分離したまま運用する**
    - 重ねるにはアプリを「開発者向け集中アプリ」に作り替える必要があるが、
      **発信の都合で製品を歪めない**という判断
  - この2つから出た帰結:
    - **記事はアプリの集客手段として数えない**。集客はすべて App Store 側（ASO）の仕事になる
      - 混ぜると「DLが伸びない→記事が足りないのでは」という誤った打ち手に迷い込むため
    - **ユーザー数の最大化はKPIから降りる**。「App Storeに存在すること」が実績の本体
    - **12,800円（KAN-19 / 1.1）はYesに倒れる**。回収を検討する投資ではなく、実績を作る参加費
  - 詰まった点: 市場調査（0.10）を **12,800円を払う判断の直前**にやっていた。順序が逆
    - 再発防止: `docs/roi-checklist.md` を作り、**新規アプリは着手前に通す**ルールを
      CLAUDE.md に追加した。所要1時間で「1時間だけ現実を見る」のが目的
  - あわせて README.md の「進捗は `docs/wbs.md` が正」という記述を修正
    （進捗の正はJiraに移っていたのに、READMEだけ古いままだった）
  - **調査の誤りを1件訂正**（レビュー中にユーザーの指摘で発覚）
    - 誤: 「無料で完成度の高い競合がいるので、このカテゴリで収益化は現実的でない」
    - 正: **カテゴリとしては収益化できている**。AppBlock（1,500万ユーザー）は $29.99/年 で、
      無料枠はブロック4時間まで・プロファイル2個までの明確な制限つき。Opal は $99.99/年
    - 完全無料の ScreenZen は**業界の外れ値**（寄付運営・50万MAU）。それ1件で全体を一般化していた
    - 決定1は維持するが**理由を差し替え**: 「稼げないから」ではなく
      「①基本機能では課金できない（ScreenZenが無料の錨）②収益は配布の後に来る」
    - 再発防止: `docs/roi-checklist.md` の項目2に「無料competitorの**規模**と
      **上位が課金しているか**をセットで見る」を追記
  - **さらにもう1件訂正**（ユーザーが実機にScreenZenを入れて発覚）
    - 誤: 「ScreenZenはアップセル無し」（レビュー記事の記述をそのまま採用していた）
    - 正: **インストール直後の1画面目がチップ要求**（¥800 / ¥1,500 / ¥3,000）。
      機能は全部無料でSkipもできるが、「無料を維持できないかもしれないので、
      いま払えば生涯アクセスを確保できる」という**不安を作る文面**になっている
    - 価格モデルは2種類ではなく3種類だった:
      フリーミアム（機能制限あり）/ **チップ+心理的フック（制限なし）** / 買い切り
    - 再発防止: `docs/roi-checklist.md` に「**上位3本は実際にインストールして最初の3画面を見る**」を追加。
      **実機が二次情報を覆したのはiOS 26.4に続き2例目**
  - 成果物: `docs/growth.md` / `docs/roi-checklist.md`（+ `docs/market-research.md` の訂正2件）
- 1.15 [DEV] 匿名公開の前提整備（屋号化・ドメイン・EU配信除外）（2h + 手続き待ち約1ヶ月）→ KAN-27
  - App Store公開時に**匿名運用が崩れる制約が2件**見つかった
    1. **個人登録（Individual）だと販売者名が戸籍上の本名になる**（Apple公式ヘルプに明記）
    2. **EU配信するとDSA要件で住所・電話がApp Storeのページに公開される**（2025-02-17以降必須）
  - 決定（2026-09-12〜13）:
    - **EU配信は外す**（日本公開のみ）。日本語アプリなので損失ほぼゼロ、費用ゼロ
    - **屋号化ルート**を取る: 開業届 → D-U-N-S（Apple経由なら無料）→ Apple組織変更 → デベロッパ名変更（別申請）
      - Apple公式は「個人事業主はIndividualで」「屋号(DBA)は組織として不可」だが、日本では個人事業主のまま通った実録が複数ある。**グレー**
      - 費用・税金はほぼゼロ（副業所得が年20万円以下なら確定申告不要。無料アプリなので所得はマイナス）
      - 注意: 開業届を出したまま退職すると失業手当の対象外（退職前に廃業届で回避）。就業規則の副業規定は本人が確認
      - D-U-N-Sは個人事業主だと原則自宅住所で登録。**住所が出ることは許容**と判断し、TSRへの事前確認は省略
    - **屋号: `DeepInception`**（1語・スペースなし・CamelCaseで固定）
      - ドメインやBundle IDはスペースが入らないため、表記を1つに揃える（ハンドル3分裂の再発防止）
      - **既知の衝突**: 同名のLLMジェイルブレイク手法の論文あり（arXiv 2311.03191）。把握したうえで採用
      - **商標（J-PlatPat実査）**: 「DeepInception」完全一致は0件。ただし「Inception」は**区分09（ソフトウェア）でワーナー・ブラザース等が登録・存続中**。
        → 屋号には使うが**アプリ名にはInceptionを含めない**
    - **ドメイン: `deepinception.co`**（2026-09-13 Cloudflare Registrarで取得、$30/年・更新も同額）
      - `.com` は取得済み（2021年・別人）。`.io` はチャゴス諸島返還でccTLD廃止議論あり、Cloudflareで$50と高い
      - `.jp` は**登録者名をWhoisで隠せない**。既存の実名ドメインで実際に本名が公開されているのを確認した。gTLD（.co）はWhois代行が効く
      - Cloudflareは卸値販売で更新料が上がらない。WHOISは標準で非公開
  - 詰まった点:
    - **商標を完全一致だけで検索し「問題なし」と報告していた**。部分一致で見ると区分09に既存登録があった
      - 再発防止: `docs/roi-checklist.md` に「名前は部分一致で商標を見る」を追加
      - **確認範囲が狭いのに結論を広く書く**のは、AppBlock（フリーミアムを無料と記載）・ScreenZen（アップセル無しと記載）に続き**3例目**
    - Playwrightのページスナップショット（`~/Library/Logs/paraiso-booking/playwright/*.yml`）に、ブラウザの**自動入力されたパスワードが平文で残る**ことが判明。値が入っていた3ファイルのうち1件を削除（残り2件も削除対象）
      - 原因はChromeではなく「ログイン情報を持つプロファイルに自動化を繋いでいる」構成。自動入力された値はページ上のテキストとして読める
  - 残作業（Jiraで管理）: 開業届 / D-U-N-S申請 / Apple組織変更 / Bundle ID変更（1.16）
- 1.16 [DEV] Bundle ID を `co.deepinception.hinablocks` に変更（0.3h）→ KAN-28
  - 屋号 `DeepInception` とドメイン `deepinception.co`（1.15）に合わせた
  - 旧: `io.github.hina-tsukuru.HinaBlocks` / 新: `co.deepinception.hinablocks`（テストは `.tests` / `.uitests`）
  - **Bundle IDはApp Store公開後は変更できない**（変えると別アプリ扱いになり、既存ユーザーの更新が途切れる）。
    X が今も `com.atebits.Tweetie2`、Instagram が `com.burbn.instagram` のまま
  - 証明書・Family Controlsのentitlementを作る**前**に変えたので、作り直しは発生しない
  - 以前の要望「`io.github.hina-tsukuru` を今後のアプリにも使える形にしたい」への答え。2本目以降は `co.deepinception.<アプリ名>` にする
  - 有料プログラム承認後の検証（2026-09-19）:
    - **Team ID は変わらなかった**。Apple は無料 Personal Team の Team ID を有料加入後もそのまま引き継ぐため、`DEVELOPMENT_TEAM = 7GV9WUC8NP` は書き換え不要だった
    - 有料チームでの署名を実証。`generic/platform=iOS` の署名付きビルドが成功し、`co.deepinception.hinablocks` のプロファイルが発行された
    - **Family Controls (Development) が capability 一覧に出た** → Phase 2 のゲート条件は満たした
  - 詰まった点:
    - **古いプロファイルを使い回して「成功」に見えた**。最初の署名付きビルドは通ったが、使われたのは加入前に作られた**期限7日**＝無料 Personal Team のプロファイルだった
      - 判定方法: **無料は有効期限7日、有料は1年**。キャッシュ（`~/Library/Developer/Xcode/UserData/Provisioning Profiles/`）を退避して再ビルドし、1年のプロファイルが出ることを確認した
      - 再発防止: 署名まわりを変えたら、**ビルドが通ったか**ではなく**発行されたプロファイルの中身**を見る（CLAUDE.md「環境の前提」に追記）
    - **同じ Apple ID に勤務先の Developer チームが同居している**。ポータルは既定で勤務先チームを選んだ状態で開いた。個人チームを明示的に選ばないと、証明書やApp IDを勤務先側に作ってしまう（CLAUDE.md「環境の前提」に追記）
    - Xcode のGUIキャッシュ（`defaults read com.apple.dt.Xcode`）は有料化後も `isFreeProvisioningTeam = 1` のまま。ビルドの実体には影響しない
- 1.17 [DEV] deepinception.co のWebサイト公開（3h）→ KAN-29
  - Apple の組織登録（1.15）の条件として、**組織ドメインの公開Webサイト**が必要と公式ヘルプで確認
    - "websites that contain minimal content or display a message from a domain registrar won't be accepted"
    - 同じく**組織ドメインのメールアドレス**も必要（Gmail不可）→ `contact@deepinception.co` を Cloudflare Email Routing で作成済み（受信専用・Gmailへ転送、転送テスト済み）
  - 方針:
    - 置き場所は **GitHub Pages**（`gh` が既に使える。新しい外部サービス連携が不要。無料）
    - hina-blocks とは**別リポジトリ**（DeepInception の看板サイト。今後のアプリも載せる）
    - 日本語 + 英語
    - **本名・住所は載せない**。運営者表記は DeepInception、連絡先は `contact@deepinception.co`
    - 丸の内ヒナの名前はひとまずサイトに出さない
  - 内容: トップ（紹介）/ アプリ（HinaBlocks・開発中）/ プライバシーポリシー / 連絡先
    - プライバシーポリシーは App Store 公開時にもどのみち必要なので、ここで先に作る
  - サブタスク: ページ作成 → GitHub Pages 有効化・カスタムドメイン設定 → Cloudflare DNS に Pages 用レコード追加 → HTTPS 確認
    - DNS は**リポジトリ側でドメインを設定してから**向ける（先に向けると、他人のPagesにドメインを取られる可能性があるため）
    - Email Routing の MX/TXT は消さない
- 1.18 [DEV] deepinception.co のなりすまし対策（GitHubドメイン検証・DMARC）（0.5h）→ KAN-30
  - 1.17（サイト公開）の後片付け
  - **DMARC**: Cloudflare DNS に `_dmarc` の TXT（`v=DMARC1; p=reject; sp=reject; adkim=r; aspf=r`）を追加
    - このドメインからはメールを**送っていない**（Email Routing の受信・転送だけ）ので、なりすましメールを「拒否」する一番強い設定にした。受信・転送には影響しない
    - レポート送り先（rua）は付けていない（毎日の集計レポートが Gmail に届くため）
    - 将来 `contact@` から送信する場合は、SPF/DKIM を整えるまで一時的に `p=none` に下げる
  - **GitHub Pages のドメイン検証**: hina-tsukuru アカウントで `deepinception.co` を Verified に
    - 目的: 他人の GitHub リポジトリが `deepinception.co` やそのサブドメインを Pages に使う「ドメイン乗っ取り」を防ぐ
    - GitHub が指定する TXT（`_github-pages-challenge-hina-tsukuru`）を Cloudflare に登録して Verify
  - 詰まった点:
    - 検証済みドメインを登録する API がなく（`gh api user/pages/domains` が 404）、ブラウザで操作する必要があった
    - 自動化用 Chrome が GitHub にログインしておらず、夜間は進められなかった（ログインはユーザーが行うルール）
    - hina-tsukuru の登録メールアドレスがすぐに分からなかった。GitHub はユーザー名でもサインインできる
- 1.19 [DEV] Xcode を更新して実機実行のブロッカーを解消（0.5h）→ KAN-31
  - 症状: 実機ビルドが `The developer disk image could not be mounted on this device.` で失敗する
  - 原因: **端末の iOS が Xcode より新しい**。iPhone 16 Pro が iOS 26.7 なのに対し、Xcode 26.6 には 26.7 用の Developer Disk Image（デバッグ機能を端末に一時的に載せる部品）が入っていなかった
    - デベロッパモードは `enabled`、ペアリング・ロック解除も問題なしと確認済み（設定の問題ではない）
  - 対処: Xcode 26.6 → **27.0**（Build 27A266a）へ更新
  - 結果: 実機ビルドが BUILD SUCCEEDED。`devicectl device install app` での実機インストールも成功（`bundleID: co.deepinception.hinablocks`）
  - 影響範囲: 実機での**実行・インストール**のみ。署名付きビルド自体は通っていたので 1.16 の他の条件には影響しなかった
  - **訂正（判断の記録）**: 調査時、原因の根拠として「`~/Library/Developer/Xcode/iOS DeviceSupport` に `26.5.2` しか無い」ことを挙げたが、**これは誤った根拠だった**
    - このフォルダの実体は `Symbols` だけで、**クラッシュログのアドレスを関数名に翻訳するためのシンボルキャッシュ**（当時 5.7GB）。デバッグ機能を端末に載せる Developer Disk Image とは別物
    - 実際 Xcode 27 では、旧来 DDI が置かれていた `Platforms/iPhoneOS.platform/DeviceSupport` 自体が存在しない
    - 結論（Xcode が端末のiOSより古いと実機で動かせない）と対処は正しく、更新で解決した。誤っていたのは**根拠の選び方**
    - 再発防止: 「DeviceSupport に端末のiOS版が無い」を判断材料にしない。**エラーメッセージが `developer disk image` と言っているか**で見る

## Phase 2: MVP実装（合計 ~20h）

> Phase 2 は起票済み（2026-09-19）。Phase 3以降は未起票で、着手するPhaseに入った時点で起票する（未来のチケットを大量に作らない）。

- 2.1 [DEV] FamilyControls: 許可リクエスト実装（3h）→ KAN-32
  - 追加したもの: `HinaBlocks.entitlements`（`com.apple.developer.family-controls`）、`ScreenTimeAuthorizationState`（状態→表示）、`ScreenTimeAuthorizationModel`（許可要求）、ContentView の作り替え
  - **状態を自前の型に移し替えている**。FamilyControls の `AuthorizationStatus` を直接画面に持ち込まず `ScreenTimeAuthorizationState` を挟むことで、「状態が決まったあと画面が何を出すか」をユニットテストで担保できる（テスト6件）
  - エンタイトルメントは**同期フォルダの外**（`SRCROOT` 直下）に置いた。`PBXFileSystemSynchronizedRootGroup` 配下に置くとバンドルのリソースとして扱われる可能性があるため
  - 署名後のアプリで `com.apple.developer.family-controls => true` が焼き込まれていることを `codesign -d --entitlements` で確認した
  - 詰まった点:
    - `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY = YES` が有効なため、`localizedDescription` を使うだけで `import Foundation` が必須だった（暗黙の再エクスポートに頼れない）
    - **Xcode 27 に更新したらシミュレータのランタイムが無くなっていた**。テストは実機で実行した。Family Controls はどのみち実機でしか動かないので実害はない
    - 実機でのUIテストは `Timed out while enabling automation mode.` で失敗する。iPhone 側で「UIオートメーション」を有効にする必要がある → 2.6 までに解消する
- 2.2 [DEV] FamilyActivityPicker: ブロック対象選択UI（3h）→ KAN-33
  - 追加したもの: `BlockTargetSummary`（件数→表示）、`BlockTargetStore`（選択の保持と保存）、`BlockTargetSection`（ピッカーを開くUI）
  - **選んだアプリの名前はアプリ側に渡らない**（不透明トークン設計）ので、画面に出せるのは件数だけ。UIにもその旨を明記した
  - 保存は `FamilyActivitySelection` を `Codable` で UserDefaults へ。保存先は protocol にしてテストから差し替えられるようにした
  - `selection` の `didSet` で自動保存する。同じ値が入り直したときは書き込まない
  - 詰まった点:
    - **デフォルト引数は隔離の外で評価される**。`init(storage: BlockTargetStorage = UserDefaultsBlockTargetStorage())` と書くと、`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` 下では「MainActor隔離の初期化子を非隔離の文脈から呼んでいる」という警告になる。既定値は**初期化子の本体**で組み立てる（引数を `nil` 許容にして `?? 既定値`）
    - 実際にアプリを選んだ状態はテストで作れない（トークンは iOS のピッカーしか発行しない）。そのためテストは「保存が走るか」「読み戻せるか」「壊れた値で落ちないか」に絞った
- 2.3 [DEV] ManagedSettings: シールド適用/解除（4h）→ KAN-34
- 2.4 [DEV] DeviceActivity: スケジュール機能（5h）※MVPスコープ外のため**未起票**。時間帯指定を将来やる時に着手
- 2.5 [DEV] メイン画面UI（SwiftUI）（3h）→ KAN-35
- 2.6 [DEV] 実機での結合動作確認・録画（2h）→ KAN-36
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
  - 論点: 販売者名として実名が公開される。ヒナの匿名運用をどうするかここで判断（1.1参照）
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

1. **WBSの項目をJiraのチケットにする** — 番号（1.4など）とチケット（KAN-14）が対応する状態を作る
2. **1日の作業単位は「2h以内のチケット1〜2枚」** — 平日夜なら1枚、休日なら2〜4枚
3. **着手ルール**: その日やるチケットを1枚だけ In Progress にする。**マルチタスク禁止**
4. **チケット番号は起票してから書く** — コミットに書く番号を予想で決めない（1.10の失敗）

## ペース試算

- 平日2日 x 1.5h + 週末3h = **週6h**ペース → 全体74hで**約3ヶ月**
- 平日3日 x 1.5h + 週末5h = **週9.5h**ペース → **約2ヶ月**

※ これは目安であって締切ではない。守れなかった時に自分を責めるためのものではない。

## 週次サイクル（固定ルーチン）

| 曜日 | やること |
|---|---|
| 月〜木 | デイリータスク消化（DEV中心） |
| 金 or 土 | 週1発信タイム（30分〜1h、CONTENT消化） |
| 日 | 週次レビュー（30分）※下に詳細 |

### 週次レビュー（日曜30分）の中身

**① 完了確認（5分）**
Jiraのボードを開き、今週Doneに動いた分を確認する。**動かし忘れているチケットがあればここで直す**。

**② 来週やる分を選ぶ（15分）**
チケットが増えると毎回「何からやるか」で迷うため、日曜にまとめて決めておく。
**5〜7枚だけ**を選び、ボードの上位に並べ替える。それ以外は見ない。

> ※ 「スプリント」はScrumの機能で、**カンバンボードには存在しない**。
> カンバンでは「上から順に並べて、上から取る」で運用する。

**③ 計画のズレを直す（10分）**
見積もりと実績のズレ、不要になった項目、新たに必要になった項目をWBSに反映する。
**計画は必ずズレる前提で、直す時間を最初から確保しておく**。

## AIの使い所

- デイリー: Claude Codeにチケット単位で実装を依頼（1チケット=1ブランチ=1PR）
- 週次: マージ済みPRの「詰まった点」欄を読ませて投稿案・記事ドラフトを生成
- 月次/Phase節目: WBS自体の見直し（見積もりズレの補正）をClaudeと実施
