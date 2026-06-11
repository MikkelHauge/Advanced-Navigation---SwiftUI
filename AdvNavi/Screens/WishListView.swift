import SwiftUI

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
