import SwiftUI

/// A smart navigation button that reads the nearest `Router` from the SwiftUI
/// environment and calls the appropriate navigation method on tap.
///
/// Usage — choose exactly one destination type per button:
/// ```swift
/// NavigationButton(push: .gameDetails(id: GameID(3))) { Text("Details") }
/// NavigationButton(sheet: .gamePlotSummary(id: GameID(3)))  { Text("Summary") }
/// NavigationButton(fullScreen: .gameGallery(id: GameID(3))) { Text("Gallery") }
/// ```
///
/// The button looks up the `Router` via `@Environment(Router.self)`, which
/// resolves to the closest router in the view hierarchy (injected by
/// `NavigationContainer`).
struct NavigationButton<Label: View>: View {
    @Environment(Router.self) private var router

    let push: PushDestination?
    let sheet: SheetDestination?
    let fullScreen: FullScreenDestination?
    let label: Label

    init(
        push: PushDestination? = nil,
        sheet: SheetDestination? = nil,
        fullScreen: FullScreenDestination? = nil,
        @ViewBuilder label: () -> Label
    ) {
        self.push = push
        self.sheet = sheet
        self.fullScreen = fullScreen
        self.label = label()
    }

    var body: some View {
        Button {
            if let push {
                router.push(push)
            } else if let sheet {
                router.present(sheet: sheet)
            } else if let fullScreen {
                router.present(fullScreen: fullScreen)
            }
        } label: {
            label
        }
    }
}
