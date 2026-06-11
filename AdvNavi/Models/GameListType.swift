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
