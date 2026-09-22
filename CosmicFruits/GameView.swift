import SwiftUI

struct GameView: View {
    @EnvironmentObject private var store: GameStore
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            header
            reelStage
            controls
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                iconButton { CosmicIcon.House() } action: {
                    store.autoPlay = false
                    store.route = .home
                }
                Spacer(minLength: 0)
                HStack(spacing: 24) {
                    score(title: "COINS", value: CosmicFormat.coins(store.coins), gold: false)
                    score(title: "BEST WIN", value: CosmicFormat.coins(store.bestWin), gold: true)
                }
                Spacer(minLength: 0)
                iconButton { CosmicIcon.Gear() } action: {
                    showSettings = true
                }
            }
            Wordmark(size: 18)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 12)
        .frame(height: 124)
        .sheet(isPresented: $showSettings) {
            SettingsView().environmentObject(store)
        }
    }

    private func score(title: String, value: String, gold: Bool) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(Cosmic.body(10, weight: .bold))
                .tracking(0.8)
                .foregroundStyle(Cosmic.muted)
            HStack(spacing: 4) {
                CosmicIcon.Coin()
                Text(value)
                    .font(Cosmic.display(18))
                    .foregroundStyle(gold ? Cosmic.gold : Cosmic.ice)
                    .monospacedDigit()
            }
        }
    }

    private func iconButton<Icon: View>(@ViewBuilder icon: () -> Icon, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            icon()
                .frame(width: 44, height: 44)
                .background(Cosmic.panelSoft, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Cosmic.reelBorder, lineWidth: 1)
                )
        }
        .buttonStyle(NeonButtonStyle())
    }

    private var reelStage: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                CosmicIcon.Spark()
                Text(store.banner)
                    .font(Cosmic.display(12))
                    .foregroundStyle(Cosmic.gold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                CosmicIcon.Spark()
            }
            .padding(.horizontal, 16)
            .frame(height: 34)
            .background(Color(red: 21 / 255, green: 25 / 255, blue: 51 / 255).opacity(0.91), in: Capsule())
            .overlay(Capsule().stroke(Cosmic.gold, lineWidth: 1))
            .shadow(color: .black.opacity(0.6), radius: 12)

            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 59 / 255, green: 79 / 255, blue: 121 / 255), location: 0),
                                .init(color: Color(red: 19 / 255, green: 25 / 255, blue: 47 / 255), location: 0.18),
                                .init(color: Color(red: 18 / 255, green: 22 / 255, blue: 45 / 255), location: 0.82),
                                .init(color: Color(red: 83 / 255, green: 99 / 255, blue: 132 / 255), location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { col in
                        VStack(spacing: 6) {
                            ForEach(0..<3, id: \.self) { row in
                                symbolCell(store.grid[row][col], highlight: store.paylineHit && row == 1)
                            }
                        }
                        .padding(6)
                        .frame(height: 298)
                        .background(Cosmic.void, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Cosmic.reelBorder, lineWidth: 1)
                        )
                    }
                }
                .padding(10)

                Rectangle()
                    .fill(Cosmic.magenta)
                    .frame(height: 3)
                    .shadow(color: Cosmic.magenta.opacity(0.6), radius: 8)
                    .padding(.horizontal, 4)

                HStack {
                    CosmicIcon.PaylineDot()
                    Spacer()
                    CosmicIcon.PaylineDot()
                }
                .padding(.horizontal, -7)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Cosmic.cyan, lineWidth: 2)
            )
            .shadow(color: Cosmic.cyan.opacity(0.55), radius: 10)
            .shadow(color: .black.opacity(0.55), radius: 12)
            .frame(height: 356)

            HStack {
                Text("LAST WIN")
                    .font(Cosmic.body(12, weight: .bold))
                    .foregroundStyle(Cosmic.muted)
                Spacer()
                Text("+ \(CosmicFormat.coins(store.lastWin))")
                    .font(Cosmic.display(22))
                    .foregroundStyle(Cosmic.gold)
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 14)
        .padding(.top, 4)
        .padding(.bottom, 12)
        .frame(height: 444)
    }

    private func symbolCell(_ symbol: SlotSymbol, highlight: Bool) -> some View {
        Text(symbol.emoji)
            .font(.system(size: 48))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    stops: [
                        .init(color: Color(red: 49 / 255, green: 58 / 255, blue: 104 / 255), location: 0),
                        .init(color: Color(red: 23 / 255, green: 29 / 255, blue: 61 / 255), location: 0.48),
                        .init(color: Color(red: 13 / 255, green: 16 / 255, blue: 40 / 255), location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(highlight ? Cosmic.gold : Color.clear, lineWidth: 2)
            )
            .scaleEffect(highlight ? 1.04 : 1)
            .animation(.spring(response: 0.32, dampingFraction: 0.72), value: highlight)
            .animation(.easeInOut(duration: 0.08), value: symbol)
    }

    private var controls: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                betSideButton("−", color: Cosmic.cyan, action: store.decreaseBet)
                VStack(spacing: 2) {
                    Text("BET AMOUNT")
                        .font(Cosmic.body(10, weight: .bold))
                        .tracking(0.6)
                        .foregroundStyle(Cosmic.muted)
                    Text("\(store.bet)")
                        .font(Cosmic.display(22))
                        .foregroundStyle(Cosmic.ice)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(Color(red: 21 / 255, green: 25 / 255, blue: 51 / 255).opacity(0.91), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Cosmic.reelBorder, lineWidth: 1)
                )
                betSideButton("+", color: Cosmic.magenta, action: store.increaseBet)
            }

            HStack(spacing: 14) {
                Button {
                    store.maxBet()
                } label: {
                    VStack(spacing: 4) {
                        CosmicIcon.Coins()
                        Text("MAX BET")
                            .font(Cosmic.body(10, weight: .bold))
                            .foregroundStyle(Cosmic.ice)
                    }
                    .frame(width: 92, height: 58)
                    .background(Cosmic.panelSoft, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Cosmic.reelBorder, lineWidth: 1)
                    )
                }
                .buttonStyle(NeonButtonStyle())
                .disabled(store.isSpinning)

                Button {
                    Task { await store.spin() }
                } label: {
                    VStack(spacing: 2) {
                        CosmicIcon.SpinMark()
                        Text("SPIN")
                            .font(Cosmic.display(24))
                            .foregroundStyle(Cosmic.ice)
                    }
                    .frame(width: 110, height: 96)
                    .background(
                        LinearGradient(
                            colors: [Cosmic.cyan, Cosmic.violet, Cosmic.magenta],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        in: Capsule()
                    )
                    .overlay(Capsule().stroke(Cosmic.ice, lineWidth: 2))
                    .shadow(color: Cosmic.magenta.opacity(0.6), radius: 10)
                    .scaleEffect(store.isSpinning ? 0.94 : 1)
                }
                .buttonStyle(NeonButtonStyle())
                .disabled(!store.canSpin && !store.isSpinning)
                .opacity(store.canSpin || store.isSpinning ? 1 : 0.55)

                Button {
                    store.toggleAuto()
                } label: {
                    VStack(spacing: 4) {
                        CosmicIcon.AutoArrows()
                        Text("AUTO SPIN")
                            .font(Cosmic.body(10, weight: .bold))
                            .foregroundStyle(Cosmic.ice)
                    }
                    .frame(width: 92, height: 58)
                    .background(Cosmic.autoFill, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Cosmic.magenta, lineWidth: 1)
                    )
                }
                .buttonStyle(NeonButtonStyle())
                .opacity(store.autoPlay ? 1 : 0.92)
            }
            .frame(height: 96)

            Text("TAP SPIN • WIN UP TO \(CosmicFormat.coins(store.bestWin)) COINS")
                .font(Cosmic.body(10, weight: .regular))
                .foregroundStyle(Cosmic.muted)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .frame(height: 276)
    }

    private func betSideButton(_ title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Cosmic.display(28, weight: .medium))
                .foregroundStyle(color)
                .frame(width: 56, height: 56)
                .background(Cosmic.panelSoft, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(color, lineWidth: 1)
                )
        }
        .buttonStyle(NeonButtonStyle())
        .disabled(store.isSpinning)
    }
}
