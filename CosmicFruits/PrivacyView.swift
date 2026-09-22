import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("隐私政策")
                        .font(.title2.bold())
                    Text("Cosmic Fruits 是完全单机的休闲游戏。金币、下注和赢分只保存在本机，不构成赌博，也无法兑换真实货币。")
                    Text("应用不会上传账号、不会请求通讯录，也不会发起支付。")
                    Text("如需清除数据，可在设置中重置进度，或直接删除应用。")
                    Text("继续使用即表示你理解这是一款本地娱乐产品。")
                        .foregroundStyle(.secondary)
                }
                .padding(20)
            }
            .background(Cosmic.bg.ignoresSafeArea())
            .foregroundStyle(Cosmic.ice)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("关闭") { dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
        .presentationDetents([.large])
    }
}
