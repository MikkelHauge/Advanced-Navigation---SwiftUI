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
