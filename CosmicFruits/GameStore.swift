import SwiftUI
import UIKit

enum AppRoute {
    case loading
    case home
    case game
}

enum SlotSymbol: String, CaseIterable, Identifiable {
    case cherry, lemon, grape, watermelon, orange

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .cherry: "🍒"
        case .lemon: "🍋"
        case .grape: "🍇"
        case .watermelon: "🍉"
        case .orange: "🍊"
        }
    }

    var lineMultiplier: Int {
        switch self {
        case .cherry: 20
        case .watermelon: 12
        case .grape: 10
        case .lemon: 8
        case .orange: 6
        }
    }

    static func randomSpin() -> SlotSymbol {
        let bag: [SlotSymbol] = [
            .cherry, .cherry, .cherry,
            .lemon, .lemon, .lemon,
            .grape, .grape,
            .watermelon, .watermelon,
            .orange
        ]
        return bag.randomElement() ?? .cherry
    }
}

@MainActor
final class GameStore: ObservableObject {
    @Published var route: AppRoute = .loading
    @Published var coins: Int
    @Published var bestWin: Int
    @Published var bet: Int
    @Published var grid: [[SlotSymbol]]
    @Published var isSpinning = false
    @Published var autoPlay = false
    @Published var lastWin = 400
    @Published var banner = "3× CHERRY PAYS 20×"
    @Published var paylineHit = false
    @Published var soundEnabled: Bool
    @Published var hapticEnabled: Bool

    let bets = [10, 20, 50, 100]
    private var autoTask: Task<Void, Never>?
    private let defaults = UserDefaults.standard

    init() {
        coins = defaults.object(forKey: "coins") as? Int ?? 12_480
        bestWin = defaults.object(forKey: "bestWin") as? Int ?? 8_250
        bet = defaults.object(forKey: "bet") as? Int ?? 20
        soundEnabled = defaults.object(forKey: "sound") as? Bool ?? true
        hapticEnabled = defaults.object(forKey: "haptic") as? Bool ?? true
        grid = GameStore.mockGrid()
    }

    var canSpin: Bool { !isSpinning && coins >= bet }

    func persist() {
        defaults.set(coins, forKey: "coins")
        defaults.set(bestWin, forKey: "bestWin")
        defaults.set(bet, forKey: "bet")
        defaults.set(soundEnabled, forKey: "sound")
        defaults.set(hapticEnabled, forKey: "haptic")
    }

    func decreaseBet() {
        guard !isSpinning, let idx = bets.firstIndex(of: bet), idx > 0 else { return }
        bet = bets[idx - 1]
        persist()
        haptic(.light)
    }

    func increaseBet() {
        guard !isSpinning, let idx = bets.firstIndex(of: bet), idx < bets.count - 1 else { return }
        bet = bets[idx + 1]
        persist()
        haptic(.light)
    }

    func maxBet() {
        guard !isSpinning else { return }
        bet = bets.last ?? 100
        persist()
        haptic(.medium)
    }

    func toggleAuto() {
        autoPlay.toggle()
        haptic(.light)
        if autoPlay {
            Task { await spin() }
        } else {
            autoTask?.cancel()
        }
    }

    func resetProgress() {
        autoPlay = false
        autoTask?.cancel()
        coins = 12_480
        bestWin = 8_250
        bet = 20
        lastWin = 400
        banner = "3× CHERRY PAYS 20×"
        paylineHit = false
        grid = GameStore.mockGrid()
        persist()
    }

    func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard hapticEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    func spin() async {
        guard canSpin else {
            if coins < bet {
                autoPlay = false
                banner = "NOT ENOUGH COINS"
            }
            return
        }

        isSpinning = true
        paylineHit = false
        lastWin = 0
        coins -= bet
        persist()
        haptic(.rigid)

        for tick in 0..<16 {
            grid = GameStore.freshGrid()
            try? await Task.sleep(nanoseconds: UInt64(35_000_000 + tick * 9_000_000))
        }

        grid = GameStore.freshGrid()
        let middle = [grid[1][0], grid[1][1], grid[1][2]]
        if middle[0] == middle[1], middle[1] == middle[2] {
            let payout = bet * middle[0].lineMultiplier
            paylineHit = true
            lastWin = payout
            coins += payout
            bestWin = max(bestWin, payout)
            banner = "3× \(middle[0].rawValue.uppercased()) PAYS \(middle[0].lineMultiplier)×"
            haptic(.heavy)
        } else {
            banner = "3× CHERRY PAYS 20×"
            haptic(.light)
        }
        persist()
        isSpinning = false

        if autoPlay {
            autoTask?.cancel()
            autoTask = Task {
                try? await Task.sleep(nanoseconds: 800_000_000)
                guard !Task.isCancelled, autoPlay else { return }
                await spin()
            }
        }
    }

    private static func freshGrid() -> [[SlotSymbol]] {
        (0..<3).map { _ in (0..<3).map { _ in SlotSymbol.randomSpin() } }
    }

    static func mockGrid() -> [[SlotSymbol]] {
        [
            [.cherry, .watermelon, .lemon],
            [.lemon, .cherry, .cherry],
            [.grape, .orange, .grape]
        ]
    }
}
