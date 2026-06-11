import CoreGraphics

/// Defines the two card sizes used in the grid-based game list (see `Readme.md`).
/// The `width` and `height` properties drive `LazyVGrid` column constraints.
enum GameCardSize {
    case large
    case small

    var width: CGFloat {
        switch self {
        case .large: 160
        case .small: 80
        }
    }

    var height: CGFloat {
        switch self {
        case .large: 240
        case .small: 120
        }
    }
}
