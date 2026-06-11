import SwiftUI

struct StudioDetailsScreen: View {
    let studioID: StudioID

    var body: some View {
        List {
            Text("Studio ID: \(studioID.value)")
        }
        .navigationTitle("Studio \(studioID.value)")
    }
}
