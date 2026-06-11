/// Categorises lists of games. Used as an associated value on
/// `PushDestination.gameList(_:)` so the destination knows which list to show.
/// Conforms to `Hashable` (required by `PushDestination`).
enum GameListType: Hashable, CaseIterable {
    case upcoming
    case topRated
    case popular

    var title: String {
        switch self {
        case .upcoming: "Upcoming"
        case .topRated: "Top Rated"
        case .popular: "Popular"
        }
    }
}
