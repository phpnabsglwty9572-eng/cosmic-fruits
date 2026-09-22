import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: GameStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("体验") {
                    Toggle("震动反馈", isOn: $store.hapticEnabled)
                    Toggle("音效占位", isOn: $store.soundEnabled)
                }
                Section("进度") {
                    Button("重置金币与纪录", role: .destructive) {
                        store.resetProgress()
                    }
                }
                Section("关于") {
                    Text("Cosmic Fruits 是单机霓虹水果机，金币仅用于本地娱乐，不能兑换真实货币。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Cosmic.bg)
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        store.persist()
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.medium])
    }
}
