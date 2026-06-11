## Implementation Summary

The navigation system described below has been fully implemented. Here is the file structure:

```
AdvNavi/
├── Models/                     # Supporting data types
│   ├── GameID.swift            # Hashable+Identifiable game identifier wrapper
│   ├── StudioID.swift          # Hashable studio identifier wrapper
│   ├── GameListType.swift      # Enum for game list categories
│   ├── GameCardSize.swift      # Card dimension constants
│   └── GameCardViewData.swift  # Identifiable card data model
├── Navigation/                 # Core navigation infrastructure
│   ├── Config.swift            # App-wide constants (deep link scheme)
│   ├── TabDestination.swift    # Enum for tab selection
│   ├── PushDestination.swift   # Enum for navigation stack pushes (Hashable)
│   ├── SheetDestination.swift  # Enum for sheet presentations (Identifiable)
│   ├── FullScreenDestination.swift # Enum for full-screen covers (Identifiable)
│   ├── Destination.swift       # Umbrella enum wrapping all destination types
│   ├── Router.swift            # @Observable class managing navigation state
│   ├── NavigationButton.swift  # Smart button that dispatches to the nearest Router
│   ├── NavigationContainer.swift # View that owns a Router and sets up NavigationStack
│   ├── DestinationViewFactory.swift # Maps destination values to SwiftUI views
│   ├── DeepLinkParser.swift    # URL → Destination parser with a static factory
│   └── DeepLink.swift          # Deep link registry and dispatch
├── Screens/                    # Demo screens showcasing the navigation
│   ├── GameDetailsScreen.swift
│   ├── StudioDetailsScreen.swift
│   ├── GameListView.swift
│   ├── GameCardView.swift
│   ├── GamePlotSummaryScreen.swift
│   ├── GameGalleryScreen.swift
│   └── WishListView.swift
├── ContentView.swift           # Root TabView with per-tab NavigationContainers
└── AdvNaviApp.swift            # App entry point (unchanged)
```

### How the pieces connect

1. **ContentView** creates a root `Router` (level 0) and three child routers (level 1, one per tab).
2. Each tab wraps its content in a **NavigationContainer**, which owns that tab's child router and sets up a `NavigationStack(path:)`, `.sheet(item:)`, and `.fullScreenCover(item:)` bound to the router's state.
3. **NavigationButton** reads the nearest `Router` from the SwiftUI environment and calls the appropriate navigation method (`push`, `present(sheet:)`, `present(fullScreen:)`).
4. **DestinationViewFactory** is the mapping function that converts a destination enum into the corresponding SwiftUI screen.
5. **DeepLink** iterates registered **DeepLinkParser** values to convert incoming URLs into `Destination` values, which the active router then processes.

---

## Solution components

### Destination + subtypes
Destination has 4 subtypes, based on available destination types, such as sheet.
- Tab destination
- Push destination
- Sheet destination
- FullScreen destination

example for Push destination, using a video game as example:
```swift
gameDetails(id: GameID)
studioDetails(id: StudioID)
gameList(_: GameListType)
```

for a details page you might need to fetch data, to show the contents, using the game id.
This means if we got a game id, we can navigate to the game details page, from anywhere in the app.

Mapping function:
Destination -> View.
A function that builds views for the destination types. 
For example, from push we can go to: gameDetails, studioDetails and a gameList.
So we can do something like this:

@Viewbuilder func view(for destination: PushDestination) -> some View

case gameDetails(id: GameID) 
then it can use the gameID like so:

GameDetailsScreen(gameID: id)

we do this for all destination types

### Router and Navigation Container

the router contains the state for navigation, and looks like this
```swift
@Observable
final class Router {
    let id = UUID()
    let level: Int

    /// Only relevant for the level 0 root router.
    /// Defines the selected tab.
    var selectedTab: TabDestination?

    /// Values presented in the navigation stack.
    var navigationStackPath: [PushDestination] = []

    /// Currently presented sheet (if any).
    var presentingSheet: SheetDestination?

    /// Currently presented fullscreen cover (if any).
    var presentingFullScreen: FullScreenDestination?

    /// Reference to the parent router to form a hierarchy.
    /// Router levels increase for child routers.
    weak var parent: Router?
}
```
setting the right state for the router shoudl result in the right navigation. Where the state use the destination values. 

The the navigation Container owns the router object and looks sort of like this:
```swift
struct NavigationContainer<Content: View>: View {
    @State var router: Router
    @ViewBuilder var content: () -> Content

    var body: some View {
        NavigationStack(path: $router.navigationStackPath) {
            content()
                .navigationDestination(for: PushDestination.self) { destination in
                    view(for: destination)
                }
        }
        .sheet(item: $router.presentingSheet) { sheet in
            navigationView(for: sheet, from: router)
        }
        .fullScreenCover(item: $router.presentingFullScreen) { fullScreen in
            navigationView(for: fullScreen, from: router)
        }
        .environment(router)
        .onAppear(perform: router.setActive)
        .onDisappear(perform: router.resignActive)
        .onOpenURL(perform: openDeepLinkIfFound(for:))
    }
}
```
### Navigation Button
in the views to render content  we can use the navigation button that pushes the previously mentioned enums, like gameDetails(id: game.id)

something like this:
```swift
struct GameListView: View {
    let games: [GameCardViewData]

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(
                columns: [
                    .init(
                        .fixed(GameCardSize.large.width),
                        spacing: 8,
                        alignment: .top
                    ),
                    .init(
                        .fixed(GameCardSize.large.width),
                        spacing: 8,
                        alignment: .top
                    )
                ],
                alignment: .center,
                spacing: 24
            ) {
                ForEach(games) { game in
                    NavigationButton(push: .gameDetails(id: game.id)) {
                        GameCardView(viewData: game)
                    }
                }
            }
        }
        .gameCardSize(.large)
    }
}
```

and the navigation button is smart, depending on the context you can use different presentations, like so:

```swift
NavigationButton(push: .gameDetails(id: .init(3))) {
    Text("Game Details!")
}

NavigationButton(sheet: .gamePlotSummary(id: .init(3))) {
    Text("Game Plot/Story Summary!")
}

NavigationButton(fullScreen: .gameGallery(id: .init(3))) {
    Text("Gallery")
}
```

## TabView

The `TabView` has the parent router.

Each individual tab has a child router — one per tab. The active tab has the active router, while the other routers are inactive.

When a `NavigationButton` is tapped, it reads the current router from the environment. This will be the closest router in the hierarchy. The destination is then presented on the appropriate router.

## Deep Link Mapping Function

A deep link maps a URL to a destination.

This allows links (for example from push notifications) to navigate directly to a specific location in the app.

The first step is to create a function that takes a `URL` and maps it to a destination if the URL is supported.

For example:

```text
appname://games/123
```

could map to:

```swift
.push(.gameDetails(id: .init(gameID)))
```

The URL is matched against a collection of registered parsers until a matching destination is found.

```swift
struct DeepLink {
    static func destination(from url: URL) -> Destination? {
        guard url.scheme == Config.deepLinkScheme else {
            return nil
        }

        for parser in registeredParsers {
            if let destination = parser.parse(url) {
                return destination
            }
        }

        return nil
    }

    static let registeredParsers: [DeepLinkParser] = [
        .equal(to: ["home"], destination: .tab(.home)),
        .equal(to: ["search"], destination: .tab(.search)),
        .equal(to: ["release-calendar"], destination: .tab(.releaseCalendar)),
        .equal(to: ["wish-list"], destination: .tab(.wishList)),

        .equal(
            to: ["list", "upcoming"],
            destination: .push(.gameList(.upcoming))
        ),
        .equal(
            to: ["list", "top-rated"],
            destination: .push(.gameList(.topRated))
        ),
        .equal(
            to: ["list", "popular"],
            destination: .push(.gameList(.popular))
        ),

        .gameDetails,
        .gameDetailsDescription,
        .gameDetailsGallery,

        .gameStudioDetails
    ]
}
```

Only the active router will handle the recieved deep link


```swift
extension Router {
    func deepLinkOpen(to destination: Destination) {
        guard isActive else { return }
        navigate(to: destination)
    }
    
    func navigate(to: destination: Destination) {
        switch destination {
        case let .tab(tab):
            select(tab: tab)
        case let .push(destination): 
            push(destination)
        case let .sheet(destination): 
            present(sheet: destination)
        case let .fullScreen(destination): 
            present(fullScreen: destination)
        }
    }
    
    func select(tab destination: TabDestination) {
    if level == 0 {
        selectedTab = destination
    } else {
        parent?.select(tab: destination)
        resetContent()
    }
    }
    
    func push(_ destination: PushDestination) {
        navigationStackPath.append(destination)
    }
    
    func present(sheet destination: SheetDestination) {
        presentingSheet = destination
    }
    
    func present(fullScreen destination: FullScreenDestination) {
        presentingFullScreen = destination
    }
}
```

---

## Migrating to a different domain (e.g. a store app)

The navigation infrastructure in `Navigation/` is fully generic and reusable as-is.
To adapt it for a different app domain:

### Keep unchanged

| File | Reason |
|------|--------|
| `Config.swift` | Only defines the deep‑link URL scheme |
| `Destination.swift` | Umbrella enum — its cases wrap whatever concrete subtypes you define |
| `Router.swift` | No domain references; all associated types are generic enums |
| `NavigationButton.swift` | Dispatches to any `PushDestination` / `SheetDestination` / `FullScreenDestination` |
| `NavigationContainer.swift` | Generic over its content; works with any destination types |
| `DeepLinkParser.swift` | Generic parser struct — rename your scheme in `Config.swift` and you're done |
| `DeepLink.swift` | Only the `registeredParsers` array content changes; the struct and extension pattern stay |

### Replace domain models (`Models/`)

```
GameID          → ProductID
StudioID        → CategoryID   (or delete)
GameListType    → ProductListType (e.g. .trending, .onSale, .newArrivals)
GameCardSize    → your sizing enum
GameCardViewData → your product card data model
```

### Update destination enums (`Navigation/`)

Rename the cases and their associated value types to match your domain:

| Enum | Game‑app example | Store‑app example |
|------|-----------------|-------------------|
| `TabDestination` | `.home`, `.search`, `.wishList` | `.shop`, `.cart`, `.account` |
| `PushDestination` | `.gameDetails(id:)`, `.studioDetails(id:)`, `.gameList(_:)` | `.productDetails(id:)`, `.categoryList(id:)`, `.searchResults(_:)` |
| `SheetDestination` | `.gamePlotSummary(id:)` | `.productReviews(id:)` |
| `FullScreenDestination` | `.gameGallery(id:)` | `.productGallery(id:)` |

### Update the view factory (`Navigation/DestinationViewFactory.swift`)

Swap the `switch` arms to match your new destination cases:

```swift
case let .productDetails(id): ProductDetailsScreen(productID: id)
case let .productReviews(id): ProductReviewsScreen(productID: id)
// etc.
```

### Update deep‑link parsers (`Navigation/DeepLink.swift`)

Replace the entries in `registeredParsers` to match your new URL scheme:

```swift
// Before:  .equal(to: ["games", "popular"], destination: .push(.gameList(.popular)))
// After:   .equal(to: ["products", "trending"], destination: .push(.productList(.trending)))
```

### Replace screens (`Screens/`)

Write new SwiftUI views that use `NavigationButton` with your new destination types.
The pattern is identical — just point at your own screens.

### Rebuild `ContentView`

Keep the `TabView` + per‑tab `NavigationContainer` structure. Swap the
`Router` setup code is unchanged; your new screens go inside the tab closures.

```
NavigationContainer(router: shopRouter) {
    ProductListView(productListType: .trending)
}
.tabItem { Label("Shop", systemImage: "bag") }
.tag(TabDestination.shop)
```

### Summary

```
Copy:    Navigation/   (7 generic files — zero changes needed)
Swap:    Models/       (5 files — rename types)
Update:  Destination enums (4 files — rename cases and associated values)
Update:  DestinationViewFactory (1 switch statement)
Update:  DeepLink.registeredParsers (1 array of parsers)
Replace: Screens/      (write your own)
Rebuild: ContentView   (same pattern, new content)
```
