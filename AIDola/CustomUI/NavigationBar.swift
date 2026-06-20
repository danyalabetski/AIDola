import SwiftUI

struct NavigationBar: View {
    let image: String
    let title: String
    let dateString: String
    let backAction: VoidClosure
    let historyAction: VoidClosure

    var body: some View {
        HStack(spacing: 32) {
            Button(action: backAction) {
                Image(Images.Chat.back.rawValue)
            }

            HStack(spacing: 12) {
                Image(image)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(Color.white)
                        .font(.system(size: 20, weight: .semibold))

                    if dateString != "" {
                        Text(dateString)
                            .foregroundColor(Color.white.opacity(0.6))
                            .font(.system(size: 14, weight: .regular))
                    }
                }
            }

            Spacer()

            Button(action: historyAction) {
                Image(Images.Chat.historyImage.rawValue)
            }
        }
    }
}
