//
//  MusicPlayerProtocol.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/11.
//

import SwiftUI
import MusicKit

protocol MusicPlayerProtocol {
    var stationType: StationType { get set }
    var status: ApplicationMusicPlayer.PlaybackStatus { get }
    var title: String? { get }
    var isPlaying: Bool { get }
    
    func loadMusic() async throws
    func updateStation(_ stationType: StationType)
    func play() async throws
    func pause()
    func stop()
    func forward() async throws
    func backward() async throws
}

final class MusicPlayerMock: MusicPlayerProtocol {
    var stationType: StationType = .classic
    var status: ApplicationMusicPlayer.PlaybackStatus = .playing
    var title: String? = nil
    var isPlaying: Bool = false
    
    func loadMusic() async throws {}
    func updateStation(_ stationType: StationType) {}
    func play() async throws {}
    func pause() {}
    func stop() {}
    func forward() async throws {}
    func backward() async throws {}
}
