import Foundation
import Observation

@Observable
final class Router {
    let id = UUID()
    let level: Int
    var selectedTab: TabDestination?
    var navigationStackPath: [PushDestination] = []
    var presentingSheet: SheetDestination?
    var presentingFullScreen: FullScreenDestination?
    weak var parent: Router?

    init(level: Int = 0, parent: Router? = nil) {
        self.level = level
        self.parent = parent
    }

    private static weak var activeRouter: Router?

    var isActive: Bool {
        Router.activeRouter === self
    }

    func setActive() {
        Router.activeRouter = self
    }

    func resignActive() {
        if Router.activeRouter === self {
            Router.activeRouter = nil
        }
    }

    func deepLinkOpen(to destination: Destination) {
        guard isActive else { return }
        navigate(to: destination)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case let .tab(tabDest): select(tab: tabDest)
        case let .push(pushDest): push(pushDest)
        case let .sheet(sheetDest): present(sheet: sheetDest)
        case let .fullScreen(fullScreenDest): present(fullScreen: fullScreenDest)
        }
    }

    func select(tab destination: TabDestination) {
        if level == 0 {
            selectedTab = destination
        } else {
            parent?.select(tab: destination)
            resetContent()
        }
    }

    func push(_ destination: PushDestination) {
        navigationStackPath.append(destination)
    }

    func present(sheet destination: SheetDestination) {
        presentingSheet = destination
    }

    func present(fullScreen destination: FullScreenDestination) {
        presentingFullScreen = destination
    }

    func resetContent() {
        navigationStackPath.removeAll()
        presentingSheet = nil
        presentingFullScreen = nil
    }
}
