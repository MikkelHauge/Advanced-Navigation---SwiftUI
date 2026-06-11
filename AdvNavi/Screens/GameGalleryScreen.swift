import SwiftUI

struct GameGalleryScreen: View {
    let gameID: GameID
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        TabView {
            ForEach(1...5, id: \.self) { index in
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Text("Screenshot \(index)")
                            .foregroundStyle(.secondary)
                    }
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(.page)
        .navigationTitle("Gallery")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }
}
