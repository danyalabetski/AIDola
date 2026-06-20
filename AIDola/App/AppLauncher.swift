import Foundation

final class AppLauncher {
    enum LaunchState {
        case loading
        case onboarding
        case paywall
        case coordinator
    }

    var stateChangeHandler: ((LaunchState) -> Void)?

    private var _launchState = LaunchState.onboarding {
        didSet {
            stateChangeHandler?(_launchState)
        }
    }

    var launchState: LaunchState {
        get {
            return _launchState
        }
        set {
            _launchState = newValue
        }
    }

    func onboarding() {
        launchState = .onboarding
    }

    func load() {
        launchState = .coordinator
    }
}
