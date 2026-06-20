import ApphudSDK
import Combine
import Foundation
import StoreKit

import ApphudSDK
import Combine

final class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    private init() {}

    @Published private(set) var products: [ApphudProduct] = []

    @Published private(set) var weeklyProduct: ApphudProduct?
    @Published private(set) var yearlyProduct: ApphudProduct?

    @Published private(set) var weeklyPrice = ""
    @Published private(set) var yearlyPrice = ""

    @Published private(set) var weeklyTitle = ""
    @Published private(set) var yearlyTitle = ""

    @Published private(set) var weeklyHasTrial = false
    @Published private(set) var yearlyHasTrial = false

    @Published private(set) var weeklyPerWeekPrice = ""
    @Published private(set) var yearlyPerWeekPrice = ""

    @MainActor
    func fetchProducts() {
        print("🚀 Fetching products from Apphud...")

        Apphud.paywallsDidLoadCallback { [weak self] paywalls, _ in
            guard let self else { return }

            guard let paywall = paywalls.first(where: {
                $0.identifier == "main"
            }) else {
                print("❌ Paywall 'main' not found")
                return
            }

            self.products = paywall.products

            for product in paywall.products {
                print("""
                ------------------------
                🧾 Name: \(product.name ?? "nil")
                🆔 Product ID: \(product.productId)
                💰 Price: \(product.skProduct?.localizedPrice ?? "unknown")
                🧪 Trial: \(product.skProduct?.introductoryPrice != nil)
                ------------------------
                """)
            }

            self.weeklyProduct = paywall.products.first {
                $0.productId.contains("week")
            }

            self.yearlyProduct = paywall.products.first {
                $0.productId.contains("year")
            }

//            self.weeklyTitle = self.weeklyProduct?.name ?? ""
//            self.yearlyTitle = self.yearlyProduct?.name ?? ""

            self.weeklyTitle = "Week"
            self.yearlyTitle = "Year"

            self.weeklyPrice = self.weeklyProduct?.skProduct?.autoPrice() ?? ""
            self.yearlyPrice = self.yearlyProduct?.skProduct?.autoPrice() ?? ""

            if let weeklyProduct = self.weeklyProduct?.skProduct {
                self.weeklyPerWeekPrice =
                    "\(weeklyProduct.priceValue(value: weeklyProduct.price)) / week"
            }

            if let yearlyProduct = self.yearlyProduct?.skProduct {
                let weeklyPrice = yearlyProduct.price.doubleValue / 52.0

                let formattedPrice = SKProduct.priceValue(
                    value: NSDecimalNumber(value: weeklyPrice),
                    locale: yearlyProduct.priceLocale
                )

                self.yearlyPerWeekPrice = "\(formattedPrice) / week"
            }

            self.weeklyHasTrial = self.weeklyProduct?.skProduct?.introductoryPrice != nil
            self.yearlyHasTrial = self.yearlyProduct?.skProduct?.introductoryPrice != nil
        }
    }

    @MainActor
    func purchase(
        product: ApphudProduct,
        completion: @escaping (Bool) -> Void
    ) {
        Apphud.purchase(product) { result in
            completion(result.subscription?.isActive() == true)
        }
    }

    @MainActor
    func restorePurchases(
        completion: @escaping (Bool) -> Void
    ) {
        Apphud.restorePurchases { subscriptions, _, error in

            if let error {
                print("❌ Restore error: \(error.localizedDescription)")
                completion(false)
                return
            }

            let restored = subscriptions?.contains {
                $0.isActive()
            } ?? false

            print("✅ Restored: \(restored)")
            completion(restored)
        }
    }

    func hasActiveSubscription() -> Bool {
        Apphud.hasActiveSubscription()
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale

        return formatter.string(from: price) ?? ""
    }
}
