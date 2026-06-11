import SwiftUI

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
