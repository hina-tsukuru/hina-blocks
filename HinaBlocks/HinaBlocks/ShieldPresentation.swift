//
//  ShieldPresentation.swift
//  HinaBlocks
//
//  シールド（ブロック）の状態から、画面に出す内容を決める（WBS 2.3 / KAN-34）。
//
//  ManagedSettings を import していないのは、この判断をシミュレータ上の
//  ユニットテストで確認できるようにするため。
//

import Foundation

/// シールドの状態と、そこから決まる表示。
struct ShieldPresentation: Equatable {

    /// いまブロックが掛かっているか。
    let isOn: Bool
    /// ブロック対象が1件以上選ばれているか。
    let hasTargets: Bool

    /// 状態の説明。
    var statusText: String {
        isOn ? "ブロック中" : "ブロックしていません"
    }

    /// 操作ボタンの文言。
    var buttonTitle: String {
        isOn ? "ブロックを解除する" : "ブロックを開始する"
    }

    /// ボタンを押せるか。
    ///
    /// **ブロック中は必ず解除できる。** 対象が空になっても解除できないと、
    /// ユーザーが自分で掛けたブロックから抜け出せなくなる。
    var canToggle: Bool {
        isOn || hasTargets
    }

    /// ボタンを押せない理由。押せるときは nil。
    var disabledReason: String? {
        canToggle ? nil : "先にブロックする対象を選んでください"
    }
}
