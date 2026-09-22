import SwiftUI
import UIKit

enum Cosmic {
    static let bg = Color(red: 7 / 255, green: 8 / 255, blue: 22 / 255)
    static let cyan = Color(red: 34 / 255, green: 232 / 255, blue: 255 / 255)
    static let magenta = Color(red: 255 / 255, green: 63 / 255, blue: 216 / 255)
    static let violet = Color(red: 125 / 255, green: 84 / 255, blue: 255 / 255)
    static let gold = Color(red: 255 / 255, green: 208 / 255, blue: 90 / 255)
    static let ice = Color(red: 247 / 255, green: 251 / 255, blue: 255 / 255)
    static let muted = Color(red: 142 / 255, green: 154 / 255, blue: 189 / 255)
    static let glow = Color(red: 155 / 255, green: 247 / 255, blue: 255 / 255)
    static let panel = Color(red: 32 / 255, green: 39 / 255, blue: 76 / 255).opacity(0.87)
    static let panelSoft = Color(red: 32 / 255, green: 39 / 255, blue: 76 / 255).opacity(0.80)
    static let marquee = Color(red: 21 / 255, green: 25 / 255, blue: 51 / 255).opacity(0.93)
    static let reelBorder = Color(red: 74 / 255, green: 91 / 255, blue: 135 / 255)
    static let void = Color(red: 2 / 255, green: 3 / 255, blue: 10 / 255)
    static let autoFill = Color(red: 36 / 255, green: 32 / 255, blue: 73 / 255)

    static var brandFont: Font {
        .system(.title2, design: .rounded).weight(.bold)
    }

    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func body(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight)
    }
}

struct CosmicBackground: View {
    var showAmbientGlow = true

    var body: some View {
        ZStack {
            Cosmic.bg
            RadialGradient(
                colors: [
                    Color(red: 24 / 255, green: 44 / 255, blue: 97 / 255),
                    Color(red: 16 / 255, green: 13 / 255, blue: 46 / 255).opacity(0.55),
                    Cosmic.bg
                ],
                center: .topLeading,
                startRadius: 20,
                endRadius: 520
            )
            if showAmbientGlow {
                Circle()
                    .fill(Cosmic.cyan.opacity(0.18))
                    .frame(width: 210, height: 210)
                    .blur(radius: 48)
                    .offset(y: 20)
            }
            star(x: 0.08, y: 0.15, size: 3)
            star(x: 0.90, y: 0.21, size: 2)
            star(x: 0.82, y: 0.72, size: 3)
        }
        .ignoresSafeArea()
    }

    private func star(x: CGFloat, y: CGFloat, size: CGFloat) -> some View {
        GeometryReader { geo in
            Circle()
                .fill(Cosmic.ice.opacity(0.85))
                .frame(width: size, height: size)
                .position(x: geo.size.width * x, y: geo.size.height * y)
        }
    }
}

struct FigmaIcon: View {
    let name: String
    var systemFallback: String
    var size: CGFloat

    var body: some View {
        Group {
            if UIImage(named: name) != nil {
                Image(name)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: systemFallback)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Cosmic.ice)
            }
        }
        .frame(width: size, height: size)
    }
}

struct NeonButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.86 : 1)
    }
}

struct Wordmark: View {
    var size: CGFloat = 26

    var body: some View {
        HStack(spacing: 8) {
            Text("COSMIC")
                .foregroundStyle(Cosmic.ice)
            Text("FRUITS")
                .foregroundStyle(Cosmic.magenta)
        }
        .font(Cosmic.display(size))
    }
}

struct FruitMachineEmblem: View {
    var fruits: [SlotSymbol] = [.cherry, .lemon, .grape]

    var body: some View {
        VStack(spacing: 10) {
            Text("✦ JACKPOT READY ✦")
                .font(Cosmic.display(11))
                .foregroundStyle(Cosmic.gold)
                .padding(.horizontal, 18)
                .frame(height: 34)
                .background(Cosmic.marquee, in: Capsule())
                .overlay(Capsule().stroke(Cosmic.gold, lineWidth: 1))

            ZStack {
                HStack(spacing: 7) {
                    ForEach(fruits) { fruit in
                        Text(fruit.emoji)
                            .font(.system(size: 46))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(
                                LinearGradient(
                                    stops: [
                                        .init(color: Color(red: 49 / 255, green: 58 / 255, blue: 104 / 255), location: 0),
                                        .init(color: Color(red: 23 / 255, green: 29 / 255, blue: 61 / 255), location: 0.55),
                                        .init(color: Color(red: 13 / 255, green: 16 / 255, blue: 40 / 255), location: 1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Cosmic.reelBorder, lineWidth: 1)
                            )
                    }
                }
                .padding(8)
                .frame(height: 142)
                .background(Cosmic.void, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                Rectangle()
                    .fill(Cosmic.magenta)
                    .frame(height: 3)
                    .shadow(color: Cosmic.magenta.opacity(0.6), radius: 8)
                    .padding(.horizontal, 6)
            }
        }
        .padding(12)
        .frame(width: 274, height: 224)
        .background(
            LinearGradient(
                stops: [
                    .init(color: Color(red: 64 / 255, green: 89 / 255, blue: 132 / 255), location: 0),
                    .init(color: Color(red: 17 / 255, green: 22 / 255, blue: 44 / 255), location: 0.32),
                    .init(color: Color(red: 25 / 255, green: 21 / 255, blue: 50 / 255), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Cosmic.cyan, lineWidth: 2)
        )
        .shadow(color: Cosmic.cyan.opacity(0.45), radius: 16)
        .shadow(color: .black.opacity(0.55), radius: 18, y: 10)
    }
}
