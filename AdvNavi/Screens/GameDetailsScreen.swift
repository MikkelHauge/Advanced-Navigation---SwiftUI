import SwiftUI

struct GameDetailsScreen: View {
    let gameID: GameID

    var body: some View {
        List {
            Section("Game Info") {
                Text("Game ID: \(gameID.value)")
            }

            Section("Actions") {
                NavigationButton(sheet: .gamePlotSummary(id: gameID)) {
                    Label("Plot / Story Summary", systemImage: "text.alignleft")
                }
                NavigationButton(fullScreen: .gameGallery(id: gameID)) {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }
                NavigationButton(push: .studioDetails(id: StudioID(gameID.value))) {
                    Label("Studio Details", systemImage: "building.2")
                }
            }
        }
        .navigationTitle("Game \(gameID.value)")
    }
}
