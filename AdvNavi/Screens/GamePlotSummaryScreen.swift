import SwiftUI

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
