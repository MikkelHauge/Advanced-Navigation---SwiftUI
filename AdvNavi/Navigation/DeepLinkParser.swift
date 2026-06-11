import Foundation

struct DeepLinkParser {
    let parse: (URL) -> Destination?

    init(parse: @escaping (URL) -> Destination?) {
        self.parse = parse
    }

    static func equal(to pathComponents: [String], destination: Destination) -> DeepLinkParser {
        DeepLinkParser { url in
            let components = url.pathComponents.filter { $0 != "/" }
            guard components == pathComponents else { return nil }
            return destination
        }
    }
}
