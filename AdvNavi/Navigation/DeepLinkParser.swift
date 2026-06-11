import Foundation

/// A parser that attempts to convert a `URL` into a `Destination`.
///
/// Use the static factory ``equal(to:destination:)`` for simple path‑based
/// URLs, or create a custom parser with a closure for more complex patterns.
///
/// Custom parsers are stored as static properties on `DeepLinkParser` via
/// extension in `DeepLink.swift` and registered in `DeepLink.registeredParsers`.
struct DeepLinkParser {
    let parse: (URL) -> Destination?

    init(parse: @escaping (URL) -> Destination?) {
        self.parse = parse
    }

    /// Creates a parser that matches URLs whose path equals the given component
    /// array and returns a fixed `Destination`.
    ///
    /// Example:
    /// ```swift
    /// .equal(to: ["home"], destination: .tab(.home))
    /// // matches "advnavi://home"
    /// ```
    static func equal(to pathComponents: [String], destination: Destination) -> DeepLinkParser {
        DeepLinkParser { url in
            let components = url.pathComponents.filter { $0 != "/" }
            guard components == pathComponents else { return nil }
            return destination
        }
    }
}
