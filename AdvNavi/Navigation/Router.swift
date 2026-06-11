import Foundation
import Observation

/// The central navigation state object. Each navigation context (a tab, a sheet,
/// a full‑screen cover) owns its own `Router` instance. Routers form a hierarchy
/// linked by the `parent` reference so that tab‑selection requests bubble up to
/// the level‑0 root router.
///
/// Observable properties (used by `NavigationContainer` bindings):
///  - ``selectedTab`` — the currently selected tab (level‑0 only).
///  - ``navigationStackPath`` — the `NavigationStack` push path.
///  - ``presentingSheet`` — the currently presented sheet.
///  - ``presentingFullScreen`` — the currently presented full‑screen cover.
///
/// Active‑router tracking:
///  Only the router whose `NavigationContainer` is currently on screen is the
///  *active* router. Deep links are only processed by the active router.
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

    // MARK: - Active‑router management

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

    // MARK: - Deep‑link entry point

    func deepLinkOpen(to destination: Destination) {
        guard isActive else { return }
        navigate(to: destination)
    }

    // MARK: - Navigation dispatch

    func navigate(to destination: Destination) {
        switch destination {
        case let .tab(tabDest): select(tab: tabDest)
        case let .push(pushDest): push(pushDest)
        case let .sheet(sheetDest): present(sheet: sheetDest)
        case let .fullScreen(fullScreenDest): present(fullScreen: fullScreenDest)
        }
    }

    // MARK: - Individual navigation actions

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
