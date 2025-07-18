//
//  MusicStoreProtocol.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/11.
//

import SwiftUI
import MusicKit

@MainActor
protocol MusicStoreProtocol {
    
    var player: MusicPlayerProtocol { get }
    var authorizationStatus: MusicAuthorization.Status { get }
    var isAuthorizationLoading: Bool { get }
    var authorizationError: Error? { get }
    var isInitialized: Bool { get }
    var isAuthorized: Bool { get }
    var isSubscribed: Bool { get }
    var isLoading: Bool { get }
    var shouldShowAuthorizationView: Bool { get }
    var isPlaying: Bool { get }
    var title: String { get }

    func requestAuthorization() async throws
    func play()
    func pause()
    func togglePlayPause()
    func stop()
    func forward()
    func backward()
    func cancel()
    func updateStation(_ station: StationType)
}

@MainActor
final class MusicStoreMock: MusicStoreProtocol {
    var player: MusicPlayerProtocol = MusicPlayerMock()
    var authorizationStatus: MusicAuthorization.Status = .authorized
    var isAuthorizationLoading: Bool = false
    var authorizationError: (any Error)? = nil
    var isInitialized: Bool = false
    var isAuthorized: Bool = false
    var isSubscribed: Bool = false
    var isLoading: Bool = false
    var shouldShowAuthorizationView: Bool = false
    var isPlaying: Bool = false
    var title: String = "Mock"
    
    func stop() {}
    func forward() {}
    func backward() {}
    func cancel() {}
    func updateStation(_ station: StationType) {}
    func requestAuthorization() async throws {}
    func togglePlayPause() {}
    func play() {}
    func pause() {}
}

@MainActor
struct MusicStoreKey: @preconcurrency EnvironmentKey {
    static let defaultValue: MusicStoreProtocol = MusicStoreMock()
}

extension EnvironmentValues {
    var musicStore: MusicStoreProtocol {
        get {
            self[MusicStoreKey.self]
        } set {
            self[MusicStoreKey.self] = newValue
        }
    }
}
