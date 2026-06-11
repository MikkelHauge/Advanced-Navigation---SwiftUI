import SwiftUI

/// Owns a `Router` instance and sets up the full SwiftUI navigation stack:
///   - `NavigationStack(path:)` bound to `router.navigationStackPath`
///   - `.navigationDestination(for: PushDestination.self)` → `DestinationViewFactory`
///   - `.sheet(item:)` → new `NavigationContainer` with a child router
///   - `.fullScreenCover(item:)` → new `NavigationContainer` with a child router
///   - `.environment(router)` so `NavigationButton` can find it
///   - `onAppear`/`onDisappear` for active‑router tracking
///   - `onOpenURL` for deep‑link handling
///
/// In a tab‑based app, each tab wraps its content in a `NavigationContainer`
/// with its own child `Router`. The root `Router` (level 0) lives at the
/// `TabView` level and handles tab‑selection.
struct NavigationContainer<Content: View>: View {
    @State var router: Router
    @ViewBuilder var content: () -> Content

    var body: some View {
        NavigationStack(path: $router.navigationStackPath) {
            content()
                .navigationDestination(for: PushDestination.self) { destination in
                    DestinationViewFactory.view(for: destination)
                }
        }
        .sheet(item: $router.presentingSheet) { sheet in
            navigationView(for: sheet, from: router)
        }
        .fullScreenCover(item: $router.presentingFullScreen) { fullScreen in
            navigationView(for: fullScreen, from: router)
        }
        .environment(router)
        .onAppear(perform: router.setActive)
        .onDisappear(perform: router.resignActive)
        .onOpenURL(perform: openDeepLinkIfFound)
    }

    private func openDeepLinkIfFound(_ url: URL) {
        guard let destination = DeepLink.destination(from: url) else { return }
        router.deepLinkOpen(to: destination)
    }

    /// Creates a new `NavigationContainer` at the next level for sheet presentation.
    private func navigationView(for destination: SheetDestination, from parent: Router) -> AnyView {
        let childRouter = Router(level: parent.level + 1, parent: parent)
        switch destination {
        case let .gamePlotSummary(id):
            let container = NavigationContainer<GamePlotSummaryScreen>(router: childRouter) {
                GamePlotSummaryScreen(gameID: id)
            }
            return AnyView(container)
        }
    }

    /// Creates a new `NavigationContainer` at the next level for full‑screen presentation.
    private func navigationView(for destination: FullScreenDestination, from parent: Router) -> AnyView {
        let childRouter = Router(level: parent.level + 1, parent: parent)
        switch destination {
        case let .gameGallery(id):
            let container = NavigationContainer<GameGalleryScreen>(router: childRouter) {
                GameGalleryScreen(gameID: id)
            }
            return AnyView(container)
        }
    }
}
