import SwiftUI

/// Maps each destination value to the corresponding SwiftUI screen.
/// Used by `NavigationContainer` in three places:
///  1. `.navigationDestination(for: PushDestination.self)` — push destinations.
///  2. `.sheet(item:)` content builder — sheet destinations.
///  3. `.fullScreenCover(item:)` content builder — full‑screen destinations.
///
/// Add a new case here whenever you add a new enum case to any destination type.
enum DestinationViewFactory {
    @ViewBuilder
    static func view(for destination: PushDestination) -> some View {
        switch destination {
        case let .gameDetails(id):
            GameDetailsScreen(gameID: id)
        case let .studioDetails(id):
            StudioDetailsScreen(studioID: id)
        case let .gameList(type):
            GameListView(gameListType: type)
        }
    }

    @ViewBuilder
    static func view(for destination: SheetDestination) -> some View {
        switch destination {
        case let .gamePlotSummary(id):
            GamePlotSummaryScreen(gameID: id)
        }
    }

    @ViewBuilder
    static func view(for destination: FullScreenDestination) -> some View {
        switch destination {
        case let .gameGallery(id):
            GameGalleryScreen(gameID: id)
        }
    }
}
