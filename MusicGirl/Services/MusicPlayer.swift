//
//  MusicPlayer.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/05.
//

import MusicKit
import Observation
import Combine
import SwiftUI

@Observable
final class MusicPlayer: MusicPlayerProtocol {
    
    // MARK: - public properties
    
    var stationType: StationType = .classic
    var status: ApplicationMusicPlayer.PlaybackStatus
    var title: String?
    
    var isPlaying: Bool {
        status == .playing
    }
    
    // MARK: - private properties
    
    @ObservationIgnored private let player = ApplicationMusicPlayer.shared
    private let state: ApplicationMusicPlayer.State
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - public methods
    
    init() {
        log("init", with: .debug)
        state = player.state
        status = state.playbackStatus
        
        state.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.status = self?.state.playbackStatus ?? .stopped
            }
            .store(in: &cancellables)
    }
    
    deinit {
        log("deinit", with: .debug)
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func loadMusic() async throws {
        let stationID = MusicItemID(stationType.musicItemID)
        let request = MusicCatalogResourceRequest<Station>(matching: \.id, equalTo: stationID)
        let response = try await request.response()
        guard let station = response.items.first else { return }
        title = station.name
        player.queue = [station]
        try await player.prepareToPlay()
    }
    
    func updateStation(_ stationType: StationType) {
        self.stationType = stationType
    }
    
    func play() async throws {
        try await player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func stop() {
        player.stop()
    }
    
    func forward() async throws {
        try await player.skipToNextEntry()
    }
    
    func backward() async throws {
        try await player.skipToPreviousEntry()
    }
}
