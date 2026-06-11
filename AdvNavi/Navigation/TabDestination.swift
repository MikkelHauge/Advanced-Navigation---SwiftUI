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
