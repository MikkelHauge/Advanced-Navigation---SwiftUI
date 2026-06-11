enum FullScreenDestination: Identifiable {
    case gameGallery(id: GameID)

    var id: String {
        switch self {
        case let .gameGallery(id): "gameGallery-\(id.value)"
        }
    }
}
