//
//  ShieldController.swift
//  HinaBlocks
//
//  ManagedSettings を使って、選んだ対象に実際のブロックを掛ける（WBS 2.3 / KAN-34）。
//

import FamilyControls
import Foundation
import ManagedSettings
import Observation

extension ManagedSettingsStore.Name {
    /// このアプリが使うストア。将来スケジュール別に分けられるよう名前を付けている。
    static let main = Self("hinablocks.main")
}

/// ブロックの適用と解除を行う。
///
/// 状態は自前で持たず **ManagedSettings のストアから読み直す**。
/// ストアの内容はアプリを終了しても iOS 側に残るため、
/// 別に ON/OFF を保存すると実態とズレる余地が生まれる。
@Observable
@MainActor
final class ShieldController {

    /// いまブロックが掛かっているか。
    private(set) var isOn = false

    @ObservationIgnored private let store = ManagedSettingsStore(named: .main)

    init() {
        refresh()
    }

    /// ストアの現在の内容から状態を読み直す。
    func refresh() {
        isOn = store.shield.applications != nil
            || store.shield.applicationCategories != nil
            || store.shield.webDomains != nil
    }

    /// 選択された対象にブロックを掛ける。
    ///
    /// 対象が空のまま掛けると「掛かっているのに何も塞がない」状態になるため、
    /// 何も選ばれていなければ何もしない。
    func turnOn(with selection: FamilyActivitySelection) {
        let summary = BlockTargetSummary(
            applicationCount: selection.applicationTokens.count,
            categoryCount: selection.categoryTokens.count,
            webDomainCount: selection.webDomainTokens.count
        )
        guard !summary.isEmpty else { return }

        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty
            ? nil
            : .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens.isEmpty ? nil : selection.webDomainTokens

        refresh()
    }

    /// ブロックを解除する。
    ///
    /// 対象の選択状態にかかわらず必ず解除できる必要があるため、
    /// 条件を付けずにストアを空にする。
    func turnOff() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        refresh()
    }

    /// 現在の表示内容。
    func presentation(hasTargets: Bool) -> ShieldPresentation {
        ShieldPresentation(isOn: isOn, hasTargets: hasTargets)
    }
}
