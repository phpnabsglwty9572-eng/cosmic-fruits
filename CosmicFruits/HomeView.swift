import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: GameStore
    @State private var showSettings = false
    @State private var showPrivacy = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Wordmark()
                Text("NEON ARCADE")
                    .font(Cosmic.body(10, weight: .bold))
                    .tracking(0.6)
                    .foregroundStyle(Cosmic.muted)
            }

            Spacer(minLength: 0)

            VStack(spacing: 20) {
                FruitMachineEmblem()
                Text("点亮好运 · 赢取宇宙大奖")
                    .font(Cosmic.body(12, weight: .semibold))
                    .foregroundStyle(Cosmic.muted)
            }

            Spacer(minLength: 0)

            VStack(spacing: 14) {
                Button {
                    store.haptic(.medium)
                    store.route = .game
                } label: {
                    Text("开始游戏")
                        .font(Cosmic.display(23))
                        .foregroundStyle(Cosmic.ice)
                        .frame(maxWidth: .infinity)
                        .frame(height: 72)
                        .background(
                            LinearGradient(
                                colors: [Cosmic.cyan, Cosmic.violet, Cosmic.magenta],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            in: Capsule()
                        )
                        .overlay(Capsule().stroke(Cosmic.ice, lineWidth: 2))
                        .shadow(color: Cosmic.magenta.opacity(0.6), radius: 12)
                }
                .buttonStyle(NeonButtonStyle())

                Button {
                    store.haptic(.light)
                    showSettings = true
                } label: {
                    Text("设置")
                        .font(Cosmic.display(17))
                        .foregroundStyle(Cosmic.ice)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Cosmic.panel, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Cosmic.cyan, lineWidth: 1)
                        )
                }
                .buttonStyle(NeonButtonStyle())

                Button("隐私政策") {
                    showPrivacy = true
                }
                .font(Cosmic.body(12, weight: .medium))
                .foregroundStyle(Cosmic.muted)
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 56)
        .padding(.bottom, 34)
        .sheet(isPresented: $showSettings) {
            SettingsView().environmentObject(store)
        }
        .sheet(isPresented: $showPrivacy) {
            PrivacyView()
        }
    }
}
