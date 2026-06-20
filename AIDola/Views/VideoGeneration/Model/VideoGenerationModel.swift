import Foundation
import SwiftUI

struct ScrollItemOffset: Equatable {
    let id: Int
    let offset: CGFloat
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [ScrollItemOffset] = []

    static func reduce(value: inout [ScrollItemOffset], nextValue: () -> [ScrollItemOffset]) {
        value = nextValue()
    }
}

protocol SelectableItem {
    var title: String { get }
}

protocol PopupSelectable: CaseIterable, Hashable {
    var title: String { get }
}

enum VideoFormat: String, CaseIterable {
    case portrait = "9:16"
    case landscape = "16:9"
    case square = "1:1"
}

extension VideoFormat: PopupSelectable {
    var title: String { rawValue }
}

enum VideoQuality: String, CaseIterable {
    case p360 = "360p"
    case p540 = "540p"
    case p720 = "720p"
    case p1080 = "1080p"
}

extension VideoQuality: PopupSelectable {
    var title: String { rawValue }
}
