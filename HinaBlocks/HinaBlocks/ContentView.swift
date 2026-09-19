//
//  ContentView.swift
//  HinaBlocks
//
//  Created by hina-tsukuru on 2026/07/26.
//

import SwiftUI

struct ContentView: View {

    @State private var authorization = ScreenTimeAuthorizationModel()
    @State private var targets = BlockTargetStore()
    @State private var shield = ShieldController()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 24) {
            statusHeader

            if let failureMessage = authorization.failureMessage {
                Text(failureMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            if authorization.state.canRequestAuthorization {
                requestButton
            }

            if authorization.state.needsSettingsApp {
                Button("設定アプリを開く") { openSettings() }
                    .buttonStyle(.bordered)
            }

            if authorization.state.isReady {
                Divider()
                BlockTargetSection(store: targets)
                Divider()
                ShieldSection(controller: shield, targets: targets)
            }
        }
        .padding(32)
        .onChange(of: scenePhase) { _, phase in
            // 設定アプリで許可を変えられても通知は来ないので、戻ってきたら読み直す。
            guard phase == .active else { return }
            authorization.refresh()
            shield.refresh()
        }
        .onChange(of: targets.selection) { _, newSelection in
            // ブロック中に対象を選び直したら、掛かっているブロックも追従させる。
            // 追従しないと、画面の選択内容と実際に塞がれているものが食い違う。
            guard shield.isOn else { return }
            shield.turnOn(with: newSelection)
        }
    }

    private var statusHeader: some View {
        VStack(spacing: 16) {
            Image(systemName: authorization.state.isReady ? "checkmark.shield" : "shield")
                .imageScale(.large)
                .font(.system(size: 48))
                .foregroundStyle(authorization.state.isReady ? .green : .secondary)

            VStack(spacing: 8) {
                Text(authorization.state.title)
                    .font(.headline)
                Text(authorization.state.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var requestButton: some View {
        Button {
            Task { await authorization.requestAuthorization() }
        } label: {
            Text("スクリーンタイムを許可する")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(authorization.isRequesting)
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    ContentView()
}
