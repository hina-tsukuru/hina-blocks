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
            }
        }
        .padding(32)
        .onChange(of: scenePhase) { _, phase in
            // 設定アプリで許可を変えられても通知は来ないので、戻ってきたら読み直す。
            if phase == .active { authorization.refresh() }
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
