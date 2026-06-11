enum SheetDestination: Identifiable {
    case gamePlotSummary(id: GameID)

    var id: String {
        switch self {
        case let .gamePlotSummary(id): "gamePlotSummary-\(id.value)"
        }
    }
}
