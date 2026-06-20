import Combine

struct ImageAndTitle {
    let image: String
    let title: String
}

final class PaywallViewModel: ObservableObject {
    let imagesAndTitles: [ImageAndTitle] = [
        ImageAndTitle(image: Images.Paywall.first.rawValue, title: "Get results in seconds"),
        ImageAndTitle(image: Images.Paywall.second.rawValue, title: "Turn any text into better writing"),
        ImageAndTitle(image: Images.Paywall.third.rawValue, title: "Simplify complex information"),
        ImageAndTitle(image: Images.Paywall.four.rawValue, title: "Create content with AI templates")
    ]
}
