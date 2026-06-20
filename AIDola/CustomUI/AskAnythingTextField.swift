import SwiftUI

import SwiftUI

struct AskAnythingButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(Images.Main.buttonMoveToChat.rawValue)
                .overlay(alignment: .leading) {
                    Text("Ask anything...")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.leading, 56)
                }
        }
    }
}
