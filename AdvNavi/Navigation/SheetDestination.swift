/// Destinations presented as a sheet via `.sheet(item:)`.
/// Conforms to `Identifiable` because `.sheet(item:)` requires an `Identifiable`
/// binding to drive presentation and dismissal.
///
///  - ``gamePlotSummary(id:)`` → `GamePlotSummaryScreen`
enum SheetDestination: Identifiable {
    case gamePlotSummary(id: GameID)

    var id: String {
        switch self {
        case let .gamePlotSummary(id): "gamePlotSummary-\(id.value)"
        }
    }
}
