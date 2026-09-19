//
//  ShieldSection.swift
//  HinaBlocks
//
//  ブロックの開始・解除UI（WBS 2.3 / KAN-34）。
//

import SwiftUI

/// ブロックの状態表示と、開始・解除のボタン。
struct ShieldSection: View {

    let controller: ShieldController
    let targets: BlockTargetStore

    private var presentation: ShieldPresentation {
        controller.presentation(hasTargets: !targets.summary.isEmpty)
    }

    var body: some View {
        VStack(spacing: 12) {
            Label(presentation.statusText, systemImage: controller.isOn ? "lock.fill" : "lock.open")
                .font(.headline)
                .foregroundStyle(controller.isOn ? .red : .secondary)

            Button {
                toggle()
            } label: {
                Text(presentation.buttonTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(controller.isOn ? .red : .accentColor)
            .disabled(!presentation.canToggle)

            if let reason = presentation.disabledReason {
                Text(reason)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func toggle() {
        if controller.isOn {
            controller.turnOff()
        } else {
            controller.turnOn(with: targets.selection)
        }
    }
}
