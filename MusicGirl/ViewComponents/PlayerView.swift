//
//  PlayerView.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/07.
//

import SwiftUI

struct PlayerView: View {
    @Environment(\.musicStore) private var musicStore: MusicStoreProtocol
    
    var body: some View {
        VStack(spacing: 12) {
            if musicStore.isLoading {
                ProgressView()
            } else {
                Text(musicStore.title)
                    .font(.caption)
                controller
            }
        }
        .padding()
        .frame(width: 200, height: 80)
        .animation(.linear, value: musicStore.isLoading)
        .background(Material.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
    }
    
    private var controller: some View {
        HStack(spacing: 32) {
            // backward
            Button(action: musicStore.backward) {
                Image(systemName: "backward.fill")
                    .imageScale(.large)
            }
            
            // play or pause
            Button(action: musicStore.togglePlayPause) {
                Image(systemName: musicStore.isPlaying ? "pause.fill" : "play.fill")
                    .imageScale(.large)
            }
            
            // forward
            Button(action: musicStore.forward) {
                Image(systemName: "forward.fill")
                    .imageScale(.large)
            }
        }
        .disabled(!musicStore.isInitialized)
    }
}

#Preview {
    ZStack {
        Image("Girl")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        PlayerView()
    }
}
