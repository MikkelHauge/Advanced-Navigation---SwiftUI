import SwiftUI

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
