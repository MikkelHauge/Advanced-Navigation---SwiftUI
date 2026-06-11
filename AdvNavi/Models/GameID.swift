struct GameID: Hashable, Identifiable {
    let value: Int
    var id: Int { value }

    init(_ value: Int) {
        self.value = value
    }
}
