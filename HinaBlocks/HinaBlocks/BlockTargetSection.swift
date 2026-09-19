//
//  BlockTargetSection.swift
//  HinaBlocks
//
//  ブロック対象を選ぶUI（WBS 2.2 / KAN-33）。
//

import FamilyControls
import SwiftUI

/// ブロック対象の選択件数を表示し、ピッカーを開く。
struct BlockTargetSection: View {

    @Bindable var store: BlockTargetStore
    @State private var isPickerPresented = false

    var body: some View {
        VStack(spacing: 12) {
            Text(store.summary.description)
                .font(.subheadline)
                .foregroundStyle(store.summary.isEmpty ? .secondary : .primary)

            Button {
                isPickerPresented = true
            } label: {
                Text(store.summary.isEmpty ? "ブロックする対象を選ぶ" : "選び直す")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            // 選んだアプリの名前はアプリ側に渡らない（不透明トークン設計）ため、
            // 「何を選んだか」を思い出せるようにここで補足しておく。
            if !store.summary.isEmpty {
                Text("選んだアプリの名前は、iOSの仕様によりアプリ側からは見えません。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .familyActivityPicker(isPresented: $isPickerPresented, selection: $store.selection)
    }
}
