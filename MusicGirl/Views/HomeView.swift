//
//  HomeView.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/05.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.musicStore) private var musicStore: MusicStoreProtocol
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("isAutoPlayOnLaunch") private var isAutoPlayOnLaunch = false
    @State private var isShowSettings: Bool = false
    @State private var currentStation: StationType = .classic
    
    private func handleIsShowSettings() {
        isShowSettings.toggle()
    }
    
    private func handleScenePhase() {
        switch scenePhase {
        case .active:
            if isAutoPlayOnLaunch {
                musicStore.play()
            }
        default:
            break
        }
    }
    
    private func handleStationChanged() {
        musicStore.updateStation(currentStation)
        log("\(musicStore.player.stationType)", with: .debug)
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $currentStation) {
                ForEach(StationType.allCases) { stationType in
                    ZStack {
                        Image(stationType.image)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    }
                }
            }
            .tabViewStyle(.page)
            .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            Button(action: handleIsShowSettings) {
                Image(systemName: "gearshape.fill")
                    .imageScale(.large)
            }
            .tint(.white)
            .padding(.trailing, 20)
        }
        .overlay(alignment: .bottom) {
            PlayerView()
                .padding(.bottom, 50)
        }
        .sheet(isPresented: $isShowSettings) {
            SettingsView()
        }
        .onChange(of: scenePhase, handleScenePhase)
        .onChange(of: currentStation, handleStationChanged)
    }
}

#Preview {
    HomeView()
}
