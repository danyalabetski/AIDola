import ApphudSDK
import SwiftUI

@main
struct AIDolaApp: App {

    @StateObject private var appStorageManager = AppStorageManager()
    @StateObject private var paywallViewModel = PaywallViewModel()

    @State private var isShouldLoadingScreen = true

    init() {
        Apphud.start(apiKey: KeysManager.shared.apphudApiKey)
    }

    var body: some Scene {
        WindowGroup {
            bodyContentView(launchState: launchState)
        }
    }

    private var launchState: AppLauncher.LaunchState {
        if isShouldLoadingScreen {
            return .loading
        }

        if appStorageManager.isShouldShowOnboarding {
            return .onboarding
        }

        if appStorageManager.isShowPaywallAfterOnboarding {
            return .paywall
        }

        return .coordinator
    }

    @ViewBuilder
    private func bodyContentView(
        launchState: AppLauncher.LaunchState
    ) -> some View {

        switch launchState {

        case .loading:
            LoadingView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isShouldLoadingScreen = false
                    }
                }

        case .onboarding:
            Color.clear
                  .ignoresSafeArea()
                  .onAppear {
                      appStorageManager.isShouldShowOnboarding = false
                  }
        case .paywall:
            PaywallView(
                viewModel: paywallViewModel,
                closeAction: {
                    appStorageManager.isShowPaywallAfterOnboarding = false
                }
            )

        case .coordinator:
            CoordinatorView()
        }
    }
}
