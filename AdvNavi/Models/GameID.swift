/// Wraps an integer game identifier.
/// Conforms to `Hashable` (required by `PushDestination` for `NavigationStack` paths)
/// and `Identifiable` (used by `GameCardViewData` and `ForEach` in lists).
struct GameID: Hashable, Identifiable {
    let value: Int
    var id: Int { value }

    init(_ value: Int) {
        self.value = value
    }
}
