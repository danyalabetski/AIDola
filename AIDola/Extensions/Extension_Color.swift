import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue >> 16) & 0xff) / 255
        let green = Double((rgbValue >> 8) & 0xff) / 255
        let blue = Double(rgbValue & 0xff) / 255

        self.init(red: red, green: green, blue: blue)
    }

    static let color_1F191F = Color(hex: "#1F191F")
    static let color_98C6F7 = Color(hex: "#98C6F7")
    static let color_EB5B92 = Color(hex: "#EB5B92")
    static let color_0B070E = Color(hex: "#0B070E")
    static let color_606060 = Color(hex: "#606060")
}
