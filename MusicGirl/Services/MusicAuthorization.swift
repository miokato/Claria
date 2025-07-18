//
//  MusicAuthorization.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/05.
//

import MusicKit
import Observation

actor AppleMusicAuthorizer {
    
    /// Request authorization for MusicKit
    func requestAuthorization() async -> MusicAuthorization.Status {
        let status = await MusicAuthorization.request()
        log("MusicAuthorization requested: \(status)", with: .info)
        return status
    }
    
    /// Get current authorization status
    func getCurrentStatus() -> MusicAuthorization.Status {
        return MusicAuthorization.currentStatus
    }
    
    /// Check subscription status
    func checkSubscriptionStatus() async throws -> MusicSubscription? {
        let subscription = try await MusicSubscription.current
        log("Subscription status: \(subscription)", with: .info)
        return subscription
    }
    
    /// Monitor subscription updates
    func subscriptionUpdates() -> AsyncStream<MusicSubscription> {
        AsyncStream { continuation in
            Task {
                for await subscription in MusicSubscription.subscriptionUpdates {
                    continuation.yield(subscription)
                }
                continuation.finish()
            }
        }
    }
}
