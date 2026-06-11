import Foundation

/// Deep‑link dispatch centre. `NavigationContainer.onOpenURL` calls
/// ``destination(from:)`` and forwards the result to the active router.
///
/// Registration:
///  - Add simple path‑based parsers directly in ``registeredParsers``.
///  - Add custom parsers as static properties on `DeepLinkParser` (see extension
///    below) and include them in the array.
///
/// URL scheme is defined in `Config.deepLinkScheme`.
enum DeepLink {
    /// Iterates all registered parsers and returns the first matching `Destination`.
    static func destination(from url: URL) -> Destination? {
        guard url.scheme == Config.deepLinkScheme else { return nil }

        for parser in registeredParsers {
            if let destination = parser.parse(url) {
                return destination
            }
        }

        return nil
    }

    /// All registered deep‑link parsers, checked in order.
    static let registeredParsers: [DeepLinkParser] = [
        // Tab destinations
        .equal(to: ["home"], destination: .tab(.home)),
        .equal(to: ["search"], destination: .tab(.search)),
        .equal(to: ["release-calendar"], destination: .tab(.releaseCalendar)),
        .equal(to: ["wish-list"], destination: .tab(.wishList)),

        // List destinations
        .equal(to: ["list", "upcoming"], destination: .push(.gameList(.upcoming))),
        .equal(to: ["list", "top-rated"], destination: .push(.gameList(.topRated))),
        .equal(to: ["list", "popular"], destination: .push(.gameList(.popular))),

        // Custom parsers defined below
        .gameDetails,
        .gameDetailsDescription,
        .gameDetailsGallery,
        .gameStudioDetails,
    ]
}

// MARK: - Custom deep‑link parsers

extension DeepLinkParser {
    /// `advnavi://games/<id>` → `.push(.gameDetails(id:))`
    static let gameDetails = DeepLinkParser { url in
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count == 2,
              components[0] == "games",
              let gameID = Int(components[1])
        else { return nil }
        return .push(.gameDetails(id: GameID(gameID)))
    }

    /// `advnavi://games/<id>/description` → `.sheet(.gamePlotSummary(id:))`
    static let gameDetailsDescription = DeepLinkParser { url in
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count == 3,
              components[0] == "games",
              let gameID = Int(components[1]),
              components[2] == "description"
        else { return nil }
        return .sheet(.gamePlotSummary(id: GameID(gameID)))
    }

    /// `advnavi://games/<id>/gallery` → `.fullScreen(.gameGallery(id:))`
    static let gameDetailsGallery = DeepLinkParser { url in
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.count == 3,
              components[0] == "games",
              let gameID = Int(components[1]),
              components[2] == "gallery"
        else { return nil }
        return .fullScreen(.gameGallery(id: GameID(gameID)))
    }

    /// `advnavi://studios/games/<id>` → `.push(.studioDetails(id:))`
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
