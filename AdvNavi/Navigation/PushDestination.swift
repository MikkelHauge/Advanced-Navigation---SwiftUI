/// Destinations pushed onto a `NavigationStack` via `Router.navigationStackPath`.
/// Conforms to `Hashable` because `NavigationStack(path:)` requires a
/// `Binding<[Hashable]>` type for its path.
///
/// Each case carries the data needed to build the target screen:
///  - ``gameDetails(id:)`` → `GameDetailsScreen`
///  - ``studioDetails(id:)`` → `StudioDetailsScreen`
///  - ``gameList(_:)`` → `GameListView`
enum PushDestination: Hashable {
    case gameDetails(id: GameID)
    case studioDetails(id: StudioID)
    case gameList(GameListType)
}
