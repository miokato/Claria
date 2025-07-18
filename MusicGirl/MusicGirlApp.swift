//
//  MusicGirlApp.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/05.
//

import SwiftUI

@main
struct MusicGirlApp: App {
    @State private var purchseStore = PurchaseStore()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.musicStore, MusicStore())
                .environment(\.purchaseStore, purchseStore)
                .task {
                    await purchseStore.updatePurchasedProducts()
                }
        }
    }
}
