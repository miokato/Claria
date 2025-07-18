//
//  MusicStore.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/06.
//

import Observation
import MusicKit
import UIKit

@Observable @MainActor
final class MusicStore: MusicStoreProtocol {
    // MARK: - public properties
    let player: MusicPlayerProtocol = MusicPlayer()
    var authorizationStatus: MusicAuthorization.Status = .notDetermined
    var isAuthorizationLoading = false
    var authorizationError: Error?
    var isInitialized = false
    var isLoading = false
    
    var title: String {
        player.title ?? "No Name Station"
    }
    
    var isAuthorized: Bool {
        authorizationStatus == .authorized
    }
    
    var isSubscribed: Bool {
        subscription?.canPlayCatalogContent ?? false
    }
    
    var shouldShowAuthorizationView: Bool {
        authorizationStatus != .authorized || !isSubscribed
    }
    
    var isPlaying: Bool {
        player.isPlaying
    }
    
    // MARK: - private properties
    private let authorizer = AppleMusicAuthorizer()
    private var subscription: MusicSubscription?
    private var subscriptionTask: Task<Void, Never>?
    private var playbackStateTask: Task<Void, Never>?
    
    // MARK: - public methods
    init() {
        Task {
            isLoading = true
            try? await checkCurrentAuthorizationStatus()
            await startMonitoringSubscription()
            
            // 認証済みユーザーの音楽自動読み込み
            if isAuthorized && isSubscribed {
                do {
                    try await player.loadMusic()
                    log("Music loaded successfully for authorized user", with: .info)
                } catch {
                    log("Failed to load music: \(error)", with: .error)
                }
            }
            
            // 初期化完了
            isInitialized = true
            isLoading = false
        }
    }
    
    func requestAuthorization() async throws {
        isAuthorizationLoading = true
        authorizationError = nil
        
        let status = await authorizer.requestAuthorization()
        authorizationStatus = status
        
        if status == .authorized {
            subscription = try await authorizer.checkSubscriptionStatus()
        }
       
        try await player.loadMusic()
        
        isAuthorizationLoading = false
    }
    
    func play() {
        Task {
            do {
                try await player.play()
                log("Started playing music", with: .info)
            } catch {
                log("Failed to play music: \(error)", with: .error)
            }
        }
    }
    
    func pause() {
        player.pause()
        log("Paused music", with: .info)
    }
    
    func togglePlayPause() {
        playTapHaptic()
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func stop() {
        player.stop()
    }
    
    func forward() {
        Task {
            do {
                playTapHaptic()
                try await player.forward()
                log("Skipped to next track", with: .info)
            } catch {
                log("Failed to skip to next track: \(error)", with: .error)
            }
        }
    }
    
    func backward() {
        Task {
            do {
                playTapHaptic()
                try await player.backward()
                log("Skipped to previous track", with: .info)
            } catch {
                log("Failed to skip to previous track: \(error)", with: .error)
            }
        }
    }
    
    func cancel() {
        subscriptionTask?.cancel()
        playbackStateTask?.cancel()
    }
    
    func updateStation(_ stationType: StationType) {
        Task {
            do {
                isLoading = true
                player.updateStation(stationType)
                try await player.loadMusic()
                isLoading = false
            } catch {
                log("\(error)", with: .error)
                isLoading = false
            }
        }
    }
    
    // MARK: - private methods
    
    private func playTapHaptic() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func checkCurrentAuthorizationStatus() async throws {
        authorizationStatus = await authorizer.getCurrentStatus()
        
        if authorizationStatus == .authorized {
            subscription = try await authorizer.checkSubscriptionStatus()
        }
    }
    
    private func startMonitoringSubscription() async {
        subscriptionTask?.cancel()
        
        subscriptionTask = Task {
            for await subscription in await authorizer.subscriptionUpdates() {
                self.subscription = subscription
                log("Subscription updated: \(subscription)", with: .info)
            }
        }
    }
}
