//
//  SettingsView.swift
//  MusicGirl
//
//  Created by mio kato on 2025/07/08.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.purchaseStore) private var purchaseStore: PurchaseStoreProtocol
    @AppStorage("isAutoPlayOnLaunch") private var isAutoPlayOnLaunch = false
    @Environment(\.dismiss) private var dismiss
    @State private var isShowAlert = false
    
    var product: Product? {
        purchaseStore.products.first
    }
    
    var purchaseProductId: String? {
        purchaseStore.purchasedProductIDs.first
    }

    // MARK: - private methods
    
    private func handleIsAutoPlayOnLaunch() {}
    
    
    /// Tipボタンを押下
    private func handleTipButtonTapped(_ product: Product) {
        Task {
            do {
                let isSuccess = try await purchaseStore.purchase(product)
                if isSuccess {
                    isShowAlert.toggle()
                }
            } catch {
                log("\(error)", with: .error)
            }
        }
    }
    
    /// 画面表示
    private func handleAppear() {
        Task {
            do {
                try await purchaseStore.loadProducts()
            } catch {
                log("\(error)", with: .error)
            }
        }
    }
    
    // MARK: - body
    
    var body: some View {
        Form {
            Section("Feature") {
                Toggle(isOn: $isAutoPlayOnLaunch) {
                    Text("Auto-play on launch")
                }
            }
            if let _ = purchaseProductId {
                ThanksView(text: "Thank you for your support")
            } else {
                TipView(product: product,
                        onTapButton: handleTipButtonTapped)
            }
        }
        .onAppear(perform: handleAppear)
        .onChange(of: isAutoPlayOnLaunch, handleIsAutoPlayOnLaunch)
        .alert("Thank you for your support ❤️", isPresented: $isShowAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    SettingsView()
}
