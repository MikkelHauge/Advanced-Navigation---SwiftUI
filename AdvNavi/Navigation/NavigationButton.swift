import SwiftUI

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
