import Combine
import SwiftUI

final class AppStorageManager: ObservableObject {
    @AppStorage("isShouldShowOnboarding") var isShouldShowOnboarding: Bool = true
    @AppStorage("isShowPaywallAfterOnboarding") var isShowPaywallAfterOnboarding: Bool = true
}
