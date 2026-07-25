# hina-blocks

**スクリーンタイム1日9時間のOLが、自分をスマホから守るアプリをAIと作る記録。**

エンジニアではない人間が、Claude Code に指示を出しながら iOS アプリを1本作ります。
コードだけでなく、企画・要件定義・タスク管理・CI/CD まで含めた**開発プロセス全体を公開**するリポジトリです。

作っているのは、**指定したアプリを開けなくする iOS アプリ**（Apple の Screen Time API を使用）。

---

## なぜ公開しているか

このプロジェクトには2つの目的があります。

1. **自分のスマホ依存を実際に治すこと**（1日9時間は多すぎる）
2. **AI駆動開発とDevOpsを、非エンジニアがどこまでやれるか試すこと**

2つ目のため、普通の個人開発ならやらないところまで意図的にやっています。
うまくいった話より**詰まった話**の方が役に立つと思うので、失敗もそのまま残します。

---

## リポジトリの構成

| パス | 内容 |
|---|---|
| `docs/wbs.md` | WBS（**作業と進捗のマスター**） |
| `docs/requirements.md` | MVP要件定義 |
| `docs/agenda.md` | Phase全体の見取り図 |
| `docs/workflow.md` | プロジェクトの回し方（図解） |
| `docs/character.md` | 発信キャラの設定 |
| `docs/setup.md` | 別マシンで環境を作る手順 |
| `content/articles/` | 連載記事の原本（markdown） |
| `content/drafts/` | 投稿案・記事の書き溜め |
| `content/assets/hina/` | キャラのアイコン・表情差分・ヘッダー画像 |
| `CLAUDE.md` | Claude Code への前提共有（作業ルール） |

記事の**原本はこのリポジトリ**にあります。Zenn は現時点の公開先です。

---

## MVPの範囲

「アプリを選んで、ボタンでブロックのON/OFFを切り替える」——まずこれだけを確実に動かします。

**入れるもの**
- ブロック対象アプリの選択（FamilyActivityPicker）
- 手動でのブロック開始／解除（ManagedSettings）

**入れないもの**（意図的に後回し）
- 時間帯の自動スケジュール、ポモドーロ式
- Safariサイトのブロック
- 使用時間の統計、解除時のパスワード、ウィジェット、複数プロファイル

詳細は [docs/requirements.md](docs/requirements.md) を参照。

---

## 技術スタック

- **言語/UI**: Swift / SwiftUI（外部ライブラリは原則使わない）
- **主要フレームワーク**: FamilyControls / ManagedSettings / DeviceActivity
- **PM**: Jira / Confluence
- **CI/CD**: GitHub Actions / fastlane（予定）

---

## プライバシー方針

**ユーザーのデータは一切外部に送信しません。** 選択したアプリの情報は端末内に閉じます。

なお Screen Time API の設計上、アプリ側からは**ユーザーが選んだアプリの具体名を取得できません**（不透明トークン）。
UI もそれを前提に設計しています。

---

## 進捗

進捗は [docs/wbs.md](docs/wbs.md) が正です。
日々の記録は X、まとまった振り返りは記事として公開しています。

- X: [@hina_tsukuru](https://x.com/hina_tsukuru)
- 記事: [Zenn](https://zenn.dev/hinac)

---

## ライセンス

未定（MVP完成後に検討）
