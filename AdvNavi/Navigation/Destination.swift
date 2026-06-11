/// Umbrella enum that wraps all four destination subtypes into a single type.
/// Used by:
///  - `DeepLinkParser.parse` (returns `Destination?`)
///  - `Router.navigate(to:)` (switches on the outer case then delegates to
///    `select(tab:)`, `push(_:)`, `present(sheet:)`, or `present(fullScreen:)`)
enum Destination {
    case tab(TabDestination)
    case push(PushDestination)
    case sheet(SheetDestination)
    case fullScreen(FullScreenDestination)
}
