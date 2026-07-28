# 競合・市場調査 — スクリーンタイム系アプリ

> WBS 0.10 / KAN-23 の成果物。
> **調査日: 2026-07-28。価格は変動が激しいため、判断に使う前に再確認すること。**
> 目的: Apple Developer Program（年12,800円）を払うかの投資判断材料。

---

## 結論（3行）

1. **完全無料のアプリは存在する**（ScreenZen。サブスクなし・課金なし・全機能開放）
2. それでも有料アプリが成立しているのは、**iOS標準スクリーンタイムに「Ignore Limit」という致命的な穴がある**から
3. ただし**サードパーティアプリにも穴がある**（設定からスクリーンタイム権限をオフにされたら終わり）。誰も完全な解決策を持っていない

---

## 価格帯

| アプリ | 価格 | モデル |
|---|---|---|
| **iOS標準スクリーンタイム** | **無料** | OS標準機能 |
| **ScreenZen** | **完全無料** | 寄付で運営。サブスク・課金・プレミアム階層すべて無し |
| Forest | $3.99 | 買い切り |
| Habit Doom | 無料枠 + $2.99/月 | フリーミアム |
| ScreenBuddy | $3.99/月 · $39.99/年 · $99.99買い切り | サブスク＋買い切り |
| Opal | $9.99/月 · $99.99/年 | サブスク |
| Zentime（日本語対応） | ¥600 / ¥980 / ¥5,000 / ¥15,000 | アプリ内購入 |

**幅がとても広い。** 無料から年1万円超まで、同じジャンルで10倍以上の開きがある。

---

## なぜ無料のOS標準機能があるのに、有料アプリが売れるのか

### 「Ignore Limit」ボタン問題

iOS標準のスクリーンタイムは、制限時間に達しても **「制限を無視」ボタンをワンタップ押せば使い続けられる**。

> 自分の意志を管理したい人にとって、これは**設計上の致命的欠陥**。
> 夜11時の自分は、フィードから目を離さずにこのボタンを押す。

つまり標準機能は「**丁寧なお願い**」であって強制力がない。有料アプリはここを埋めている:

- 「無視」ボタンを取り除く
- アンインストール・強制終了・時刻変更などの回避手段に耐える
- 解除に摩擦（遅延・入力・パスワード）を挟む

**「制限」ではなく「本気度の担保」を売っている**と言える。

### ScreenZen（無料）のアプローチ

ブロックではなく**遅延を挟む**方式。アプリを開くと一度停止画面が出て、「本当に開くか」を確認させる。1日の起動回数に上限も設定できる。

「意志を強制する」のではなく「衝動と行動の間に隙間を作る」という設計。これを無料で提供している。

---

## サードパーティアプリの構造的な弱点

**有料アプリにも決定的な穴がある。**

- iOSの設定から、**サードパーティアプリのスクリーンタイム権限をトグルひとつでオフにできる**
- スクリーンタイムにパスコードをかけていても、Face IDで突破できるケースがある

Apple自身のスクリーンタイムはOSに統合されているためこの穴がないが、**サードパーティはOSの外側にいる以上、この制約から逃れられない**。

> つまり「絶対に破れないブロッカー」は、サードパーティには原理的に作れない。
> 各社が売っているのは「破るのを面倒にする度合い」の差でしかない。

---

## 日本市場（追加調査 2026-07-28）

> ⚠️ 上記の調査は英語圏中心だった（検索が米国ベースのため）。
> 日本市場は別物の可能性があったので追加で確認した。

### 日本語対応アプリは複数ある

| アプリ | 特徴 |
|---|---|
| **AppBlock** | 日本語対応。**1,500万ユーザー**を謳う。アプリ・サイト両方ブロック |
| **Jomo** | 日本語対応。Instagram / TikTok / YouTube / LINE など個別対応を明記 |
| **Blockin** | 日本語。勉強・集中用途に寄せた訴求 |
| **Zentime** | 日本語。¥600〜¥15,000 のアプリ内購入 |
| スマホ制限アプリ | 日本語。保護者による使用制限用途 |

**「日本語だとZentimeくらい」ではない。** 少なくとも5本以上が日本語で流通しており、
特に **AppBlock は1,500万ユーザー規模**で、規模的には日本のニッチプレイヤーより大きい。

### 無料のScreenZenは日本でも入手できる

**ScreenZen は日本のApp Storeでも配信されている**（`apps.apple.com/jp/app/...id1541027222`）。
アプリ名・UIは英語のままだが、**日本語の個人ブログで「マジで最強すぎる」と推されている**状態。

つまり **「無料の強力な競合」は日本市場にも存在する。**
言語の壁がある分だけ発見されにくいが、口コミで広がりつつある。

### 日本語圏でよく読まれているのは「抜け道」の話

検索結果の上位に「**iPhoneのスクリーンタイム抜け道 完全ガイド｜制限解除ワザとアプリ別対策**」
のような記事が入ってくる。

これは需要の裏返しで、**「制限をかけたい側」と「破りたい側」が同じ人**という構図を示している。
前述の「Ignore Limit問題」と同じ話が、日本語圏でも中心的な関心になっている。

---

## Screen Time API の設計上の制約（実装に効く）

- **不透明トークン設計**: `FamilyActivitySelection` で選ばれたアプリの情報は暗号化トークンで隠され、アプリ側は「どのアプリが選ばれたか」を一切知れない。プライバシー優先の設計
- **Family Controls はアプリ自体の削除を防げる**（ペアレンタルコントロール用途）
- ただし前述のとおり、**権限のオフは防げない**

---

## このプロジェクトへの示唆

### 1. 収益化は期待しない方がよい

**完全無料で高機能な競合（ScreenZen）がいる時点で、有料で売るのは相当に厳しい。**
市場は成熟していて、無料〜年1万円まで選択肢が揃っている。後発が価格で戦う余地は薄い。

### 2. だからこそ12,800円の判断は単純になる

このプロジェクトの目的は [requirements.md](requirements.md) のとおり:

> 作者自身（スクリーンタイム1日9時間）が、**スマホ依存を自分で治すために使うのが第一目的**

加えて「AI駆動開発・DevOpsの学習」と「発信」。つまり **12,800円は事業投資ではなく、学習と発信のコスト**。

「回収できるか」ではなく「**1年間の学習教材＋記事ネタとして12,800円は妥当か**」で判断すればよい。
（比較: 技術書3冊、オンライン講座1本ぶん）

### 3. MVPの設計に再考の余地がある

調査で分かった「有料アプリの存在理由 = **Ignore Limitを潰すこと**」に対し、
現在のMVP要件は **「ボタンで手動オンオフ」**（[requirements.md](requirements.md) 0.1.2）。

これは**自分でいつでも解除できる**設計であり、
標準スクリーンタイムの「Ignore Limit」と同じ弱さを持つ。

- MVPとして「まず動かす」ことを優先した判断なので、**現時点では正しい**
- ただし Phase 4 のドッグフーディングで「結局すぐ解除してしまう」問題が出る可能性が高い
- その時に「解除に摩擦を入れる」（現在は除外リスト入り）を再検討する材料になる

---

## 出典

- [The 9 Best App Blockers for iPhone, Ranked by Job — Screen Time Index](https://screentimeindex.com/posts/best-app-blockers-iphone/)
- [Free App Blockers That Actually Work (and Why Most Don't) — Screen Time Index](https://screentimeindex.com/posts/free-app-blockers-that-actually-work/)
- [ScreenZen – Stop Mindless Scrolling & Reclaim Your Time](https://screenzen.co/)
- [ScreenZen App: How It Blocks Apps, Sites, and Scrolls - Nibble Blog](https://nibble-app.com/blog/screenzen)
- [Screen Time vs Third-Party App Blockers: Which Works? — ScreenBuddy](https://www.screenbuddyapp.com/blog/screen-time-vs-third-party-app-blockers-which-is-better)
- [Apple's Screen Time API has some major issues | riedel.wtf](https://riedel.wtf/state-of-the-screen-time-api-2024/)
- [Screen time API can be disabled easily | Apple Developer Forums](https://developer.apple.com/forums/thread/727291)
- [A Developer's Guide to Apple's Screen Time APIs | Medium](https://medium.com/@juliusbrussee/a-developers-guide-to-apple-s-screen-time-apis-familycontrols-managedsettings-deviceactivity-e660147367d7)
- [Jomo - スクリーンタイム、アプリのブロックアプリ - App Store](https://apps.apple.com/jp/app/jomo-%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%BF%E3%82%A4%E3%83%A0-%E3%82%A2%E3%83%97%E3%83%AA%E3%81%AE%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF/id1609960918)
- [アプリ制限 Zentime - App Store](https://apps.apple.com/jp/app/id6748847369)

### 日本市場（追加調査）

- [AppBlock アプリ・サイトをブロックしてスマホ依存克服アプリ - App Store](https://apps.apple.com/jp/app/appblock-%E3%82%A2%E3%83%97%E3%83%AA-%E3%82%B5%E3%82%A4%E3%83%88%E3%82%92%E3%83%96%E3%83%AD%E3%83%83%E3%82%AF%E3%81%97%E3%81%A6%E3%82%B9%E3%83%9E%E3%83%9B%E4%BE%9D%E5%AD%98%E5%85%8B%E6%9C%8D/id1515753232)
- [スマホ依存対策Blockin - App Store](https://apps.apple.com/jp/app/%E3%82%B9%E3%83%9E%E3%83%9B%E4%BE%9D%E5%AD%98%E5%AF%BE%E7%AD%96blockin%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%BF%E3%82%A4%E3%83%A0%E5%88%B6%E9%99%90-%E5%8B%89%E5%BC%B7-%E9%9B%86%E4%B8%AD/id1659162950)
- [ScreenZen - Screen Time Control（日本のApp Store）](https://apps.apple.com/jp/app/screenzen-screen-time-control/id1541027222)
- [マジで最強すぎるスマホ制限アプリ「ScreenZen」を広めたい！ - note](https://note.com/ik_zz/n/ne4ee02f912f8)
- [スマホ制限アプリおすすめ7選 - Amebaチョイス](https://choice.ameba.jp/app-limiter/)
- [iPhoneのスクリーンタイム抜け道 完全ガイド - デジマーケジャーナル](https://mobinc.jp/media/2026/01/02/iphone%E3%81%AE%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%BF%E3%82%A4%E3%83%A0%E6%8A%9C%E3%81%91%E9%81%93%E6%9C%80%E6%96%B0%E5%AE%8C%E5%85%A8%E3%82%AC%E3%82%A4%E3%83%89%EF%BD%9C%E5%88%B6-3/)
