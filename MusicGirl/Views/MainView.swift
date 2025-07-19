//
//  MainView.swift
//  AIMonster
//
//  Created by mio-kato on 2025/07/05.
//

import SwiftUI

struct MainView: View {
    @Environment(\.musicStore) private var musicStore: MusicStoreProtocol
    @State private var isShowAuthorizationView = false
    
    var body: some View {
        HomeView()
            .onChange(of: musicStore.isInitialized) { _, isInitialized in
                if isInitialized && musicStore.shouldShowAuthorizationView {
                    isShowAuthorizationView = true
                }
            }
            .sheet(isPresented: $isShowAuthorizationView) {
                AppleMusicAuthorizerView()
                    .interactiveDismissDisabled(musicStore.shouldShowAuthorizationView)
            }
    }
}

#Preview {
    MainView()
}
