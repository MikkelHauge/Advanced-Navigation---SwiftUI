/// Represents the selectable tabs in the root ``TabView``.
/// Stored on the level‑0 root `Router.selectedTab` and bound to the
/// `TabView(selection:)` via `Bindable`.
/// Conforms to `Hashable` for use as the tab tag and selection value.
enum TabDestination: Hashable {
    case home
    case search
    case releaseCalendar
    case wishList

    var title: String {
        switch self {
        case .home: "Home"
        case .search: "Search"
        case .releaseCalendar: "Release Calendar"
        case .wishList: "Wish List"
        }
    }
}
