import Photos
import UIKit
import Combine

@MainActor
final class PhotoLibraryManager: ObservableObject {

    enum AccessState {
        case granted
        case denied
        case limited
    }

    static let shared = PhotoLibraryManager()

    private init() {}

    func requestAccess() async -> AccessState {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized:
            return .granted

        case .limited:
            return .limited

        case .denied, .restricted:
            return .denied

        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)

            switch newStatus {
            case .authorized:
                return .granted

            case .limited:
                return .limited

            default:
                return .denied
            }

        @unknown default:
            return .denied
        }
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        UIApplication.shared.open(url)
    }
}
