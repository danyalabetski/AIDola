import SwiftUI

final class DeviceHelper {
    static let shared = DeviceHelper()

    private init() {}

    private let miniScreenSizes: [(width: Int, height: Int)] = [
        (1080, 2340)
    ]

    var isMiniModel: Bool {
        let screenWidth = Int(UIScreen.main.nativeBounds.width)
        let screenHeight = Int(UIScreen.main.nativeBounds.height)
        return miniScreenSizes.contains { $0.width == screenWidth && $0.height == screenHeight }
    }

    var isIPhoneSE: Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            let screenHeight = UIScreen.main.nativeBounds.height
            if screenHeight == 1136 {
                return true
            }

            if screenHeight == 1334 {
                return true
            }
        }
        return false
    }

    var isiPhoneProMax: Bool {
        return UIScreen.main.nativeBounds.width >= 1284
    }
}
