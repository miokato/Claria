//
//  PurchaseStoreProtocol.swift
//  MusicGirl
//
//  Created by mio kato on 2025/07/13.
//

import SwiftUI
import StoreKit

@MainActor
protocol PurchaseStoreProtocol {
    var products: [Product] { get }
    var purchasedProductIDs: Set<String> { get }
    
    func loadProducts() async throws
    func purchase(_ product: Product) async throws -> Bool
}

@MainActor
final class PurchaseStoreMock: PurchaseStoreProtocol {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    
    func loadProducts() async throws {}
    
    func purchase(_ product: Product) async throws -> Bool {
        return true
    }
}

@MainActor
struct PurchaseStoreKey: @preconcurrency EnvironmentKey {
    static var defaultValue: PurchaseStoreProtocol = PurchaseStoreMock()
}

extension EnvironmentValues {
    var purchaseStore: PurchaseStoreProtocol {
        get {
            self[PurchaseStoreKey.self]
        } set {
            self[PurchaseStoreKey.self] = newValue
        }
    }
}
