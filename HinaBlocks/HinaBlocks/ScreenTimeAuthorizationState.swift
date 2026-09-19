//
//  ScreenTimeAuthorizationState.swift
//  HinaBlocks
//
//  スクリーンタイムの利用許可の状態と、そこから決まる画面表示。
//
//  FamilyControls の AuthorizationStatus をそのまま画面に持ち込まず、
//  自前の型に移し替えている。FamilyControls はシミュレータで動かないため、
//  このファイルだけ import せずに分けておくと、状態から表示を決める部分を
//  シミュレータ上のユニットテストで確認できる（WBS 2.1 / KAN-32）。
//

import Foundation

/// スクリーンタイムの利用許可の状態。
enum ScreenTimeAuthorizationState: Equatable {
    /// まだ一度も許可を求めていない。
    case notDetermined
    /// 許可されている。
    case approved
    /// 拒否されている。設定アプリからしか許可に戻せない。
    case denied
}

extension ScreenTimeAuthorizationState {

    /// 画面に出す見出し。
    var title: String {
        switch self {
        case .notDetermined: "スクリーンタイムの許可が必要です"
        case .approved: "準備ができています"
        case .denied: "許可されていません"
        }
    }

    /// 見出しの下に出す説明。
    var message: String {
        switch self {
        case .notDetermined:
            "アプリをブロックするには、スクリーンタイムの利用許可が必要です。下のボタンから許可してください。"
        case .approved:
            "ブロックする対象を選べます。"
        case .denied:
            "設定アプリから許可してください。「設定」→「スクリーンタイム」→「アプリとWebサイトのアクティビティ」で HinaBlocks を探します。"
        }
    }

    /// 許可を求めるボタンを出すか。許可を求められるのは未決定のときだけ。
    var canRequestAuthorization: Bool {
        self == .notDetermined
    }

    /// 設定アプリへの案内を出すか。
    ///
    /// 一度拒否されるとアプリ側からダイアログを出し直せないため、
    /// 設定アプリへ誘導するしか戻す手段がない。
    var needsSettingsApp: Bool {
        self == .denied
    }

    /// ブロック機能を使える状態か。
    var isReady: Bool {
        self == .approved
    }
}
