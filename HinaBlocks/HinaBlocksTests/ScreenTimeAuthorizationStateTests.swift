//
//  ScreenTimeAuthorizationStateTests.swift
//  HinaBlocksTests
//
//  許可状態から画面表示を決める部分のテスト（WBS 2.1 / KAN-32）。
//
//  FamilyControls 自体はシミュレータで動かないため、ここで確認するのは
//  「状態が決まったあと、画面が何を出すか」だけに絞っている。
//  許可ダイアログが実際に出るかどうかは実機で確認する。
//

import FamilyControls
import XCTest
@testable import HinaBlocks

final class ScreenTimeAuthorizationStateTests: XCTestCase {

    private let allStates: [ScreenTimeAuthorizationState] = [.notDetermined, .approved, .denied]

    /// 許可を求められるのは、まだ一度も聞いていないときだけ。
    func testCanRequestAuthorizationOnlyWhenNotDetermined() {
        XCTAssertTrue(ScreenTimeAuthorizationState.notDetermined.canRequestAuthorization)
        XCTAssertFalse(ScreenTimeAuthorizationState.approved.canRequestAuthorization)
        XCTAssertFalse(ScreenTimeAuthorizationState.denied.canRequestAuthorization)
    }

    /// 設定アプリへの案内は、拒否されたときだけ出す。
    ///
    /// 一度拒否されるとアプリ側からダイアログを出し直せないため、
    /// ここを取り違えるとユーザーが復帰できなくなる。
    func testNeedsSettingsAppOnlyWhenDenied() {
        XCTAssertTrue(ScreenTimeAuthorizationState.denied.needsSettingsApp)
        XCTAssertFalse(ScreenTimeAuthorizationState.notDetermined.needsSettingsApp)
        XCTAssertFalse(ScreenTimeAuthorizationState.approved.needsSettingsApp)
    }

    /// ブロック機能を使えるのは許可されたときだけ。
    func testIsReadyOnlyWhenApproved() {
        XCTAssertTrue(ScreenTimeAuthorizationState.approved.isReady)
        XCTAssertFalse(ScreenTimeAuthorizationState.notDetermined.isReady)
        XCTAssertFalse(ScreenTimeAuthorizationState.denied.isReady)
    }

    /// 許可を求めるボタンと設定アプリへの案内が同時に出ることはない。
    func testRequestAndSettingsGuidanceAreMutuallyExclusive() {
        for state in allStates {
            XCTAssertFalse(
                state.canRequestAuthorization && state.needsSettingsApp,
                "\(state) で許可ボタンと設定案内が同時に出ている"
            )
        }
    }

    /// どの状態でも文言が空にならず、状態ごとに違う内容になっている。
    func testEveryStateHasDistinctNonEmptyText() {
        for state in allStates {
            XCTAssertFalse(state.title.isEmpty, "\(state) の見出しが空")
            XCTAssertFalse(state.message.isEmpty, "\(state) の説明が空")
        }
        XCTAssertEqual(Set(allStates.map(\.title)).count, allStates.count)
        XCTAssertEqual(Set(allStates.map(\.message)).count, allStates.count)
    }

    /// FamilyControls の状態が、こちらの状態へ取り違えなく移し替わる。
    @MainActor
    func testMappingFromAuthorizationStatus() {
        XCTAssertEqual(ScreenTimeAuthorizationModel.state(from: .notDetermined), .notDetermined)
        XCTAssertEqual(ScreenTimeAuthorizationModel.state(from: .approved), .approved)
        XCTAssertEqual(ScreenTimeAuthorizationModel.state(from: .denied), .denied)
    }
}
