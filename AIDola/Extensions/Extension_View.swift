import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }

    func offsetPreference(id: Int) -> some View {
        background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: [
                        ScrollItemOffset(
                            id: id,
                            offset: geo.frame(in: .global).midX
                        )
                    ]
                )
            }
        )
    }
}
