# docs/workflow.md — プロジェクトの回し方

このプロジェクトを「どう回すか」を1枚にまとめたもの。
「何をやるか」は `wbs.md`、「いつやるか（全体像）」は `agenda.md`、「どう発信するか」は `character.md` を参照。

> Mermaid図はGitHub上、またはVS Codeのプレビュー（要 Mermaid拡張）で図として表示されます。

---

## 基本原則

1. **すべての作業はWBSチケットに紐づく**（WBSにない作業は、先にWBSへ追加してから着手）
2. **1チケット = 1ブランチ = 1PR**
3. **マルチタスク禁止** — その日やるチケットは1枚だけIn Progressにする
4. **PRメモは発信の素材** — 「詰まった点」「ネタ度⭐1-3」を必ず埋める

---

## デイリーの動き方

```mermaid
flowchart LR
    A[前夜 or 朝<br/>チケット1枚を<br/>In Progress] --> B[実装<br/>Claude Codeに<br/>チケット単位で依頼]
    B --> C[PR作成<br/>詰まった点・<br/>ネタ度を記入]
    C --> D[セルフレビュー<br/>→ マージ<br/>→ ブランチ削除]
    D --> E[Jira<br/>チケットをDoneへ]
```

- 作業単位は「2h以内のチケット1〜2枚」（平日夜=1枚、休日=2〜4枚）
- 3h以上のタスクは着手前にサブタスク分解する

---

## 週次サイクル（固定ルーチン）

```mermaid
flowchart TB
    subgraph Week["1週間のルーチン"]
        direction TB
        MT["月〜木<br/>デイリータスク消化<br/>（DEV中心）"]
        FS["金 or 土<br/>週1発信タイム 30分〜1h<br/>（CONTENT消化）"]
        SU["日<br/>週次レビュー 30分<br/>完了確認→翌週スプリント選定→WBS修正"]
        MT --> FS --> SU --> MT
    end
```

| 曜日 | やること |
|---|---|
| 月〜木 | デイリータスク消化（DEV中心） |
| 金 or 土 | 週1発信タイム（直近PRから投稿・記事案を生成） |
| 日 | 週次レビュー（完了確認 → 翌週スプリント5〜7枚を選定 → WBSズレ修正） |

---

## 発信フロー（PRメモが起点）

```mermaid
flowchart LR
    A[開発中<br/>PR本文に<br/>詰まった点を記録] --> B[週1発信タイム<br/>直近のマージ済みPRを<br/>Claude Codeが読む]
    B --> C[X投稿案 3-5本<br/>content/drafts/ に生成]
    B --> D[記事の書き溜め<br/>content/drafts/ に生成]
    C --> E[予約投稿<br/>丸の内ヒナ名義で分散投稿]
    D --> F[Phase節目に<br/>記事1本を仕上げ<br/>content/articles/]
    F --> G[Zennに公開]
    G --> E2[Xで公開告知]
```

- 発信の起点は常に「GitHubのPRメモ」。開発すれば素材が溜まる構造
- 単発バズ狙いではなく「小さく何度も当てる」。打席数を最大化する
- Xへの実投稿だけは人間の手が残る（レビューを挟むため、自動投稿はしない）

---

## Phase節目にやること

```mermaid
flowchart LR
    A[Phase完了] --> B[記事1本を仕上げて公開]
    A --> C[WBSの見積もりズレを補正<br/>バージョンを上げる]
    A --> D[次Phaseのスプリント準備]
```

- 各Phase終わりに連載記事を1本公開（agenda.mdの「記事化ポイント」を参照）
- WBSを改訂したらバージョン番号を上げ、変更履歴に追記
- ネタ度⭐3のPRは優先的に記事化

---

## ツールの担当（全レーンClaude Code集約）

```mermaid
flowchart TB
    CC[Claude Code<br/>全レーン実行]
    CC --> DEV[DEV: 実装・CI/CD・Git操作]
    CC --> PM[PM: Jira/Confluence<br/>Atlassian MCP経由]
    CC --> CON[CONTENT: 投稿案・記事ドラフト生成]
    CC --> CHA[CHARA: キャラ運用素材<br/>character.md 参照]
    CHAT[Claude.ai チャット<br/>プロデューサー席] -.->|要件の壁打ち・週次レビュー・<br/>戦略相談| CC
```

- 手を動かす作業・PM・発信の生成はすべてClaude Code
- Claude.aiチャットは意思決定の壁打ち、週次レビュー、WBS改訂の相談に使う
