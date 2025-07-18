//
//  PurchaseStore.swift
//  MusicGirl
//
//  Created by mio kato on 2025/07/13.
//

import StoreKit
import Observation

@MainActor @Observable
final class PurchaseStore: PurchaseStoreProtocol {
    // MARK: - public properties
    
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []

    // MARK: - private properties
    
    private var updates: Task<Void, Never>? = nil
    
    // MARK: - public methods
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    func loadProducts() async throws {
        let productIds = ["co.utomica.MusicGirl.coffeeTip"]
        products = try await Product.products(for: productIds)
        log("\(products)", with: .debug)
    }
    
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        switch result {
        case let .success(.verified(transaction)):
            log("success")
            await transaction.finish()
            await self.updatePurchasedProducts()
            return true
        case let .success(.unverified(_, error)):
            log("\(error)", with: .error)
            break
        case .pending:
            log("pending", with: .debug)
            break
        case .userCancelled:
            log("user cancelled", with: .debug)
            break
        @unknown default:
            break
        }
        return false
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    // MARK: - private methods
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                // Using verificationResult directly would be better
                await self.updatePurchasedProducts()
            }
        }
    }
}
