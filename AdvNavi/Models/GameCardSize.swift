import CoreGraphics

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
