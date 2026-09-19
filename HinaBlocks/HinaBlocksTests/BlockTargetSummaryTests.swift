//
//  BlockTargetSummaryTests.swift
//  HinaBlocksTests
//
//  選択件数から表示を決める部分のテスト（WBS 2.2 / KAN-33）。
//

import XCTest
@testable import HinaBlocks

final class BlockTargetSummaryTests: XCTestCase {

    func testEmptySelection() {
        let summary = BlockTargetSummary(applicationCount: 0, categoryCount: 0, webDomainCount: 0)
        XCTAssertTrue(summary.isEmpty)
        XCTAssertEqual(summary.totalCount, 0)
        XCTAssertEqual(summary.description, "まだ何も選んでいません")
    }

    func testTotalCountSumsEveryKind() {
        let summary = BlockTargetSummary(applicationCount: 3, categoryCount: 2, webDomainCount: 1)
        XCTAssertEqual(summary.totalCount, 6)
        XCTAssertFalse(summary.isEmpty)
    }

    /// 0件の内訳は並べない。「アプリ 3件・カテゴリ 0件」のようには出さない。
    func testDescriptionOmitsZeroKinds() {
        let onlyApps = BlockTargetSummary(applicationCount: 3, categoryCount: 0, webDomainCount: 0)
        XCTAssertEqual(onlyApps.description, "アプリ 3件")

        let appsAndCategories = BlockTargetSummary(applicationCount: 3, categoryCount: 1, webDomainCount: 0)
        XCTAssertEqual(appsAndCategories.description, "アプリ 3件・カテゴリ 1件")

        let onlyWeb = BlockTargetSummary(applicationCount: 0, categoryCount: 0, webDomainCount: 2)
        XCTAssertEqual(onlyWeb.description, "Webサイト 2件")
    }

    func testDescriptionListsEveryKindWhenAllPresent() {
        let summary = BlockTargetSummary(applicationCount: 1, categoryCount: 2, webDomainCount: 3)
        XCTAssertEqual(summary.description, "アプリ 1件・カテゴリ 2件・Webサイト 3件")
    }

    /// 1件でも選ばれていれば「まだ何も選んでいません」にはならない。
    func testAnySingleKindIsNotEmpty() {
        let cases = [
            BlockTargetSummary(applicationCount: 1, categoryCount: 0, webDomainCount: 0),
            BlockTargetSummary(applicationCount: 0, categoryCount: 1, webDomainCount: 0),
            BlockTargetSummary(applicationCount: 0, categoryCount: 0, webDomainCount: 1)
        ]
        for summary in cases {
            XCTAssertFalse(summary.isEmpty)
            XCTAssertNotEqual(summary.description, "まだ何も選んでいません")
        }
    }
}
