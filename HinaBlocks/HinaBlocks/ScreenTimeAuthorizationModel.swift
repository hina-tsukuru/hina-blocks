//
//  ScreenTimeAuthorizationModel.swift
//  HinaBlocks
//
//  FamilyControls への許可リクエストを扱う（WBS 2.1 / KAN-32）。
//

import FamilyControls
import Foundation
import Observation

/// スクリーンタイムの利用許可を要求し、現在の状態を保持する。
///
/// - Note: FamilyControls は**シミュレータでは動作しない**。動作確認は実機で行う。
@Observable
@MainActor
final class ScreenTimeAuthorizationModel {

    /// 現在の許可状態。
    private(set) var state: ScreenTimeAuthorizationState = .notDetermined

    /// 直近の失敗を説明する文言。成功時やリクエット前は nil。
    private(set) var failureMessage: String?

    /// 許可リクエストの実行中か。ボタンの二重押しを防ぐために使う。
    private(set) var isRequesting = false

    private let center: AuthorizationCenter

    init(center: AuthorizationCenter = .shared) {
        self.center = center
        refresh()
    }

    /// システムが持っている現在の許可状態を読み直す。
    ///
    /// 設定アプリで許可を変更されても通知は来ないので、
    /// 画面が前面に戻ったタイミングで呼ぶ。
    func refresh() {
        state = Self.state(from: center.authorizationStatus)
    }

    /// 許可ダイアログを出す。
    ///
    /// 拒否された場合はエラーが投げられるため、状態を読み直して `denied` を拾う。
    func requestAuthorization() async {
        guard !isRequesting else { return }
        isRequesting = true
        failureMessage = nil
        defer { isRequesting = false }

        do {
            try await center.requestAuthorization(for: .individual)
        } catch {
            failureMessage = Self.failureMessage(for: error)
        }
        refresh()
    }

    /// FamilyControls の状態を、画面が扱う自前の状態へ移し替える。
    static func state(from status: AuthorizationStatus) -> ScreenTimeAuthorizationState {
        switch status {
        case .notDetermined: .notDetermined
        case .approved: .approved
        case .denied: .denied
        @unknown default: .notDetermined
        }
    }

    /// 失敗の理由を日本語で説明する。
    ///
    /// 拒否そのものは失敗ではなく状態なので、ここでは文言を出さない。
    static func failureMessage(for error: Error) -> String? {
        if let error = error as? FamilyControlsError, error == .authorizationCanceled {
            return nil
        }
        return "許可の取得に失敗しました。時間をおいて試してください。（\(error.localizedDescription)）"
    }
}
