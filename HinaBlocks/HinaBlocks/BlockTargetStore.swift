//
//  BlockTargetStore.swift
//  HinaBlocks
//
//  ブロック対象の選択を保持し、アプリを再起動しても残るように保存する
//  （WBS 2.2 / KAN-33）。
//

import FamilyControls
import Foundation
import Observation

/// 選択内容の保存先。テストから差し替えられるように protocol にしている。
protocol BlockTargetStorage: AnyObject {
    func loadBlockTargets() -> Data?
    func saveBlockTargets(_ data: Data?)
}

/// UserDefaults に保存する既定の実装。
final class UserDefaultsBlockTargetStorage: BlockTargetStorage {

    private let defaults: UserDefaults
    private let key = "blockTargets.selection"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadBlockTargets() -> Data? {
        defaults.data(forKey: key)
    }

    func saveBlockTargets(_ data: Data?) {
        defaults.set(data, forKey: key)
    }
}

/// ブロック対象の選択を保持する。
///
/// `selection` が書き換わると自動で保存されるので、呼び出し側は保存を意識しなくてよい。
@Observable
@MainActor
final class BlockTargetStore {

    /// ユーザーが選んだブロック対象。書き換えると保存される。
    var selection: FamilyActivitySelection {
        didSet {
            guard selection != oldValue else { return }
            persist()
        }
    }

    @ObservationIgnored private let storage: BlockTargetStorage

    /// - Parameter storage: 保存先。既定では UserDefaults を使う。
    ///
    /// 既定値をデフォルト引数に書かないのは、デフォルト引数の式が隔離の外で
    /// 評価され、MainActor 隔離の初期化子を呼べないため。
    init(storage: BlockTargetStorage? = nil) {
        let storage = storage ?? UserDefaultsBlockTargetStorage()
        self.storage = storage
        self.selection = Self.decode(storage.loadBlockTargets()) ?? FamilyActivitySelection()
    }

    /// 画面に出すための選択内容のまとめ。
    var summary: BlockTargetSummary {
        BlockTargetSummary(
            applicationCount: selection.applicationTokens.count,
            categoryCount: selection.categoryTokens.count,
            webDomainCount: selection.webDomainTokens.count
        )
    }

    /// 現在の選択を保存する。
    ///
    /// 保存に失敗しても致命的ではない（次回起動時に選び直せる）ため、
    /// ここでは握りつぶさず、保存しないという結果だけを残す。
    private func persist() {
        storage.saveBlockTargets(try? JSONEncoder().encode(selection))
    }

    /// 保存されたデータを選択内容へ戻す。壊れていれば nil を返す。
    static func decode(_ data: Data?) -> FamilyActivitySelection? {
        guard let data else { return nil }
        return try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    }
}
