import SwiftUI

struct LoadingView: View {
    @EnvironmentObject private var store: GameStore
    @State private var progress: CGFloat = 0.08

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

            VStack(spacing: 30) {
                FruitMachineEmblem()
                Text("LUCK IS LIGHTING UP")
                    .font(Cosmic.display(12))
                    .foregroundStyle(Cosmic.glow)
            }

            Spacer(minLength: 0)

            VStack(spacing: 12) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Cosmic.void.opacity(0.8))
                            .overlay(Capsule().stroke(Cosmic.reelBorder, lineWidth: 1))
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Cosmic.cyan, Cosmic.magenta],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .padding(2)
                            .frame(width: max(10, (geo.size.width - 4) * progress + 4), height: 10)
                    }
                }
                .frame(height: 10)

                HStack {
                    Text("正在加载游戏资源…")
                        .font(Cosmic.body(11, weight: .semibold))
                        .foregroundStyle(Cosmic.muted)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(Cosmic.display(12))
                        .foregroundStyle(Cosmic.glow)
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 70)
        .padding(.bottom, 44)
        .onAppear {
            Task { await runLoading() }
        }
    }

    private func runLoading() async {
        for step in 1...20 {
            try? await Task.sleep(nanoseconds: 90_000_000)
            withAnimation(.easeOut(duration: 0.12)) {
                progress = CGFloat(step) / 20
            }
        }
        try? await Task.sleep(nanoseconds: 220_000_000)
        store.route = .home
    }
}
