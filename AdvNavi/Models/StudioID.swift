/// Wraps an integer studio identifier.
/// Conforms to `Hashable` because `PushDestination` uses it as an associated value
/// and must itself be `Hashable` for `NavigationStack` path storage.
struct StudioID: Hashable {
    let value: Int

    init(_ value: Int) {
        self.value = value
    }
}
