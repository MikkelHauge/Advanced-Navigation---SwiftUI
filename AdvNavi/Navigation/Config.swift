/// App-wide constants used by the navigation system.
///
/// `deepLinkScheme` is the URL scheme that `DeepLink.destination(from:)` checks
/// before attempting to parse incoming URLs. Only URLs matching this scheme are
/// processed by the registered deep-link parsers.
enum Config {
    static let deepLinkScheme = "advnavi"
}
