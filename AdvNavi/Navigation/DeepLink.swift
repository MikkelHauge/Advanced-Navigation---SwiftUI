import Foundation

enum DeepLink {
    static func destination(from url: URL) -> Destination? {
        guard url.scheme == Config.deepLinkScheme else { return nil }

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

        .equal(to: ["list", "upcoming"], destination: .push(.gameList(.upcoming))),
        .equal(to: ["list", "top-rated"], destination: .push(.gameList(.topRated))),
        .equal(to: ["list", "popular"], destination: .push(.gameList(.popular))),

        .gameDetails,
        .gameDetailsDescription,
        .gameDetailsGallery,
        .gameStudioDetails,
    ]
}

extension DeepLinkParser {
    static let gameDetails = DeepLinkParser { url in
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count == 2,
              components[0] == "games",
              let gameID = Int(components[1])
        else { return nil }
        return .push(.gameDetails(id: GameID(gameID)))
    }

    static let gameDetailsDescription = DeepLinkParser { url in
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count == 3,
              components[0] == "games",
              let gameID = Int(components[1]),
              components[2] == "description"
        else { return nil }
        return .sheet(.gamePlotSummary(id: GameID(gameID)))
    }

    static let gameDetailsGallery = DeepLinkParser { url in
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count == 3,
              components[0] == "games",
              let gameID = Int(components[1]),
              components[2] == "gallery"
        else { return nil }
        return .fullScreen(.gameGallery(id: GameID(gameID)))
    }

    static let gameStudioDetails = DeepLinkParser { url in
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count == 3,
              components[0] == "studios",
              components[1] == "games",
              let gameID = Int(components[2])
        else { return nil }
        return .push(.studioDetails(id: StudioID(gameID)))
    }
}
