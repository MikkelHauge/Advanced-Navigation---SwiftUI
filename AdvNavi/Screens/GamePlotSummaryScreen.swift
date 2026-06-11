import SwiftUI

/// Demo sheet content for a game's plot/story summary.
/// Presented via `SheetDestination.gamePlotSummary(id:)`.
/// Includes a "Done" toolbar button to dismiss the sheet.
struct GamePlotSummaryScreen: View {
    let gameID: GameID
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Text("Plot summary for game \(gameID.value)")
            .navigationTitle("Plot Summary")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
    }
}
