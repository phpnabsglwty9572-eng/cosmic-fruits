import SwiftUI

struct RootView: View {
    @EnvironmentObject private var store: GameStore

    var body: some View {
        ZStack {
            CosmicBackground(showAmbientGlow: store.route != .game)
            switch store.route {
            case .loading:
                LoadingView().transition(.opacity)
            case .home:
                HomeView().transition(.opacity)
            case .game:
                GameView()
                    .ignoresSafeArea(edges: .bottom)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: store.route)
    }
}
