import Foundation

/// Holds display data for a single game card. `Identifiable` so it can be used
/// directly in `ForEach`. The `id` is a `GameID` which is also the value used
/// by `NavigationButton(push: .gameDetails(id: …))` to form the destination.
struct GameCardViewData: Identifiable {
    let id: GameID
    let title: String
    let subtitle: String
    let imageName: String
}
