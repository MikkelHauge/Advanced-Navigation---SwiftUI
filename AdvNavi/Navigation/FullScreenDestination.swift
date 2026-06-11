/// Destinations presented as a full‑screen cover via `.fullScreenCover(item:)`.
/// Conforms to `Identifiable` because `.fullScreenCover(item:)` requires an
/// `Identifiable` binding to drive presentation and dismissal.
///
///  - ``gameGallery(id:)`` → `GameGalleryScreen`
enum FullScreenDestination: Identifiable {
    case gameGallery(id: GameID)

    var id: String {
        switch self {
        case let .gameGallery(id): "gameGallery-\(id.value)"
        }
    }
}
