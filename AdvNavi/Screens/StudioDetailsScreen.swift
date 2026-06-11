import SwiftUI

/// Demo screen for a game studio.
/// Reached via `PushDestination.studioDetails(id:)`.
struct StudioDetailsScreen: View {
    let studioID: StudioID

    var body: some View {
        List {
            Text("Studio ID: \(studioID.value)")
        }
        .navigationTitle("Studio \(studioID.value)")
    }
}
