import ApphudSDK
import Combine
import Foundation
import StoreKit

final class SubscriptionManager {
    static let shared = SubscriptionManager()
    private init() {}

    @Published private(set) var products: [ApphudProduct] = []

    func fetchProducts() {
        Apphud.fetchPlacements { placements, error in
            print("Error:", error as Any)
            print("Placements count:", placements.count)

            for placement in placements {
                print("📍 Placement:", placement.identifier)
                print("🎯 Paywall:", placement.paywall?.identifier ?? "nil")
            }
        }
    }
}
