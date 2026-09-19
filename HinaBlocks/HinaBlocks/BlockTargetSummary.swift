//
//  BlockTargetSummary.swift
//  HinaBlocks
//
//  ブロック対象の選択内容を、画面に出せる形にまとめたもの（WBS 2.2 / KAN-33）。
//
//  Screen Time API は、ユーザーが選んだアプリの**具体名をアプリ側に渡さない**
//  （不透明トークン設計）。そのため画面に出せるのは「何件選ばれているか」だけで、
//  「Instagram を選択中」のような表示はできない。この型はその制約を前提にしている。
//
//  FamilyControls を import していないのは、件数から表示を決める部分を
//  シミュレータ上のユニットテストで確認できるようにするため。
//

import Foundation

/// ブロック対象の選択件数と、そこから決まる表示。
struct BlockTargetSummary: Equatable {

    /// 個別に選ばれたアプリの数。
    let applicationCount: Int
    /// 選ばれたカテゴリ（「SNS」など）の数。
    let categoryCount: Int
    /// 選ばれたWebドメインの数。
    let webDomainCount: Int

    init(applicationCount: Int, categoryCount: Int, webDomainCount: Int) {
        self.applicationCount = applicationCount
        self.categoryCount = categoryCount
        self.webDomainCount = webDomainCount
    }

    /// 選択の合計件数。
    var totalCount: Int {
        applicationCount + categoryCount + webDomainCount
    }

    /// 何も選ばれていないか。
    var isEmpty: Bool {
        totalCount == 0
    }

    /// 選択内容の説明。内訳のうち0件のものは並べない。
    var description: String {
        guard !isEmpty else { return "まだ何も選んでいません" }

        let parts = [
            ("アプリ", applicationCount),
            ("カテゴリ", categoryCount),
            ("Webサイト", webDomainCount)
        ]
        .filter { $0.1 > 0 }
        .map { "\($0.0) \($0.1)件" }

        return parts.joined(separator: "・")
    }
}
