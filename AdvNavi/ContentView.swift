import SwiftUI

/// Root view of the app. Creates the level‑0 root `Router` and three child
/// routers (one per tab). Each tab wraps its content in a `NavigationContainer`
/// which owns that tab's child router and sets up the `NavigationStack`.
///
/// The root router handles tab‑selection via `Bindable(rootRouter).selectedTab`.
/// Parent references are wired in `onAppear` so the hierarchy is ready before
/// any navigation occurs.
struct ContentView: View {
    @State private var rootRouter = Router(level: 0)
    @State private var homeRouter = Router(level: 1)
    @State private var upcomingRouter = Router(level: 1)
    @State private var wishListRouter = Router(level: 1)

    var body: some View {
        TabView(selection: Bindable(rootRouter).selectedTab) {
            NavigationContainer(router: homeRouter) {
                GameListView(gameListType: .popular)
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(TabDestination.home)

            NavigationContainer(router: upcomingRouter) {
                GameListView(gameListType: .upcoming)
            }
            .tabItem { Label("Upcoming", systemImage: "calendar") }
            .tag(TabDestination.releaseCalendar)

            NavigationContainer(router: wishListRouter) {
                WishListView()
            }
            .tabItem { Label("Wish List", systemImage: "heart") }
            .tag(TabDestination.wishList)
        }
        .environment(rootRouter)
        .onAppear {
            homeRouter.parent = rootRouter
            upcomingRouter.parent = rootRouter
            wishListRouter.parent = rootRouter
        }
    }
}
