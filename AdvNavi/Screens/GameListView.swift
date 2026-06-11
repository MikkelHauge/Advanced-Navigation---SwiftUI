import SwiftUI

/// Demo list of games. Reached via `PushDestination.gameList(_:)`.
/// Each row is a `NavigationButton` that pushes to `GameDetailsScreen`.
struct GameListView: View {
    let gameListType: GameListType

    var body: some View {
        List {
            ForEach(1...20, id: \.self) { index in
                NavigationButton(push: .gameDetails(id: GameID(index))) {
                    HStack {
                        Text("Game \(index)")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(gameListType.title)
    }
}
