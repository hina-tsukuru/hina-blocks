//
//  ShieldPresentationTests.swift
//  HinaBlocksTests
//
//  シールドの状態から表示・操作可否を決める部分のテスト（WBS 2.3 / KAN-34）。
//

import XCTest
@testable import HinaBlocks

final class ShieldPresentationTests: XCTestCase {

    /// **ブロック中は、対象が空になっていても必ず解除できる。**
    ///
    /// ここが崩れると、ユーザーが自分で掛けたブロックから抜け出せなくなる。
    /// このアプリで最も壊してはいけない性質なので、単独でテストする。
    func testCanAlwaysTurnOffWhileOn() {
        let onWithoutTargets = ShieldPresentation(isOn: true, hasTargets: false)
        XCTAssertTrue(onWithoutTargets.canToggle)
        XCTAssertNil(onWithoutTargets.disabledReason)

        let onWithTargets = ShieldPresentation(isOn: true, hasTargets: true)
        XCTAssertTrue(onWithTargets.canToggle)
        XCTAssertNil(onWithTargets.disabledReason)
    }

    /// 対象を選んでいなければ、ブロックは開始できない。
    func testCannotTurnOnWithoutTargets() {
        let presentation = ShieldPresentation(isOn: false, hasTargets: false)
        XCTAssertFalse(presentation.canToggle)
        XCTAssertEqual(presentation.disabledReason, "先にブロックする対象を選んでください")
    }

    /// 対象を選んでいれば開始できる。
    func testCanTurnOnWithTargets() {
        let presentation = ShieldPresentation(isOn: false, hasTargets: true)
        XCTAssertTrue(presentation.canToggle)
        XCTAssertNil(presentation.disabledReason)
    }

    /// 状態によってボタンの文言が入れ替わる。
    func testButtonTitleReflectsState() {
        XCTAssertEqual(ShieldPresentation(isOn: false, hasTargets: true).buttonTitle, "ブロックを開始する")
        XCTAssertEqual(ShieldPresentation(isOn: true, hasTargets: true).buttonTitle, "ブロックを解除する")
    }

    /// 状態の説明が入れ替わる。
    func testStatusTextReflectsState() {
        XCTAssertEqual(ShieldPresentation(isOn: false, hasTargets: true).statusText, "ブロックしていません")
        XCTAssertEqual(ShieldPresentation(isOn: true, hasTargets: false).statusText, "ブロック中")
    }

    /// 押せないのは「OFF かつ対象なし」のときだけ。
    func testOnlyOffWithoutTargetsIsDisabled() {
        let combinations = [
            (isOn: false, hasTargets: false, expectedCanToggle: false),
            (isOn: false, hasTargets: true, expectedCanToggle: true),
            (isOn: true, hasTargets: false, expectedCanToggle: true),
            (isOn: true, hasTargets: true, expectedCanToggle: true)
        ]
        for combination in combinations {
            let presentation = ShieldPresentation(isOn: combination.isOn, hasTargets: combination.hasTargets)
            XCTAssertEqual(
                presentation.canToggle,
                combination.expectedCanToggle,
                "isOn=\(combination.isOn) hasTargets=\(combination.hasTargets)"
            )
        }
    }
}
