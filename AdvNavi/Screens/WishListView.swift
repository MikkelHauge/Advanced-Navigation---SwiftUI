import SwiftUI

/// Demo wish‑list screen shown in the "Wish List" tab.
/// Each row is a `NavigationButton` that pushes to `GameDetailsScreen`.
struct WishListView: View {
    var body: some View {
        List {
            ForEach(1...5, id: \.self) { index in
                NavigationButton(push: .gameDetails(id: GameID(index))) {
                    HStack {
                        Text("Game \(index)")
                        Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle("Wish List")
    }
}
