import SwiftUI

enum CosmicIcon {
    struct House: View {
        var body: some View {
            Image(systemName: "house")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Cosmic.ice)
        }
    }

    struct Gear: View {
        var body: some View {
            Image(systemName: "gearshape")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Cosmic.ice)
        }
    }

    struct Coin: View {
        var body: some View {
            ZStack {
                Circle().fill(Cosmic.gold)
                Circle().stroke(Color(red: 243 / 255, green: 155 / 255, blue: 34 / 255), lineWidth: 1.6)
            }
            .frame(width: 14, height: 14)
        }
    }

    struct Spark: View {
        var body: some View {
            Circle()
                .fill(Cosmic.gold)
                .frame(width: 6, height: 6)
                .shadow(color: Cosmic.gold.opacity(0.9), radius: 3)
        }
    }

    struct PaylineDot: View {
        var body: some View {
            ZStack {
                Circle().fill(Cosmic.magenta)
                Circle().stroke(Cosmic.ice.opacity(0.9), lineWidth: 1.2)
                Circle().fill(Cosmic.ice).frame(width: 4, height: 4)
            }
            .frame(width: 14, height: 14)
            .shadow(color: Cosmic.magenta.opacity(0.8), radius: 4)
        }
    }

    struct Coins: View {
        var body: some View {
            ZStack {
                Circle()
                    .stroke(Cosmic.ice, lineWidth: 1.6)
                    .frame(width: 11, height: 11)
                    .offset(x: 2.2, y: 2.2)
                Circle()
                    .stroke(Cosmic.ice, lineWidth: 1.6)
                    .frame(width: 11, height: 11)
                    .offset(x: -2.2, y: -2.2)
            }
            .frame(width: 18, height: 18)
        }
    }

    struct SpinMark: View {
        var body: some View {
            ZStack {
                Circle().stroke(Cosmic.ice, lineWidth: 2)
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Cosmic.ice)
            }
            .frame(width: 26, height: 26)
        }
    }

    struct AutoArrows: View {
        var body: some View {
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Cosmic.ice)
                .frame(width: 18, height: 18)
        }
    }
}

enum CosmicFormat {
    static let coins: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US")
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        return f
    }()

    static func coins(_ value: Int) -> String {
        coins.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
