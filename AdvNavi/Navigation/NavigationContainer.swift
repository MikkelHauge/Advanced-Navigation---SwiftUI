import SwiftUI

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
