//
//  AppleMusicAuthorizerView.swift
//  MusicGirl
//
//  Created by mio-kato on 2025/07/06.
//

import SwiftUI
import MusicKit

struct AppleMusicAuthorizerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.musicStore) private var musicStore: MusicStoreProtocol
    
    private func handleAuthorizationRequest() {
        Task {
            do {
                try await musicStore.requestAuthorization()
                
            } catch {
                log("\(error)", with: .error)
            }
            
            if musicStore.isAuthorized && musicStore.isSubscribed {
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            VStack(spacing: 16) {
                Text("Apple Music integration")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("To use the application, integration with Apple Music is required.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                if musicStore.authorizationStatus == .denied {
                    Text("Please allow access to Apple Music from the Settings app.")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                if musicStore.authorizationStatus == .restricted {
                    Text("Apple Music is not available due to device restrictions.")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                if let error = musicStore.authorizationError {
                    Text("An error occurred: \(error.localizedDescription)")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            Button(action: handleAuthorizationRequest) {
                if musicStore.isAuthorizationLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 250, height: 50)
                } else {
                    Text(buttonText)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 250, height: 50)
                        .background(buttonBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            .disabled(musicStore.isAuthorizationLoading || isButtonDisabled)
            
            if musicStore.isAuthorized && !musicStore.isSubscribed {
                Text("An Apple Music subscription is required.")
                    .font(.caption)
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private var buttonText: LocalizedStringKey {
        switch musicStore.authorizationStatus {
        case .notDetermined:
            return "Connect with Apple Music"
        case .denied, .restricted:
            return "Open Settings"
        case .authorized:
            return musicStore.isSubscribed ? "Done" : "Check subscription"
        @unknown default:
            return "Connect"
        }
    }
    
    private var buttonBackgroundColor: Color {
        switch musicStore.authorizationStatus {
        case .denied, .restricted:
            return .gray
        case .authorized:
            return musicStore.isSubscribed ? .green : .orange
        default:
            return .accentColor
        }
    }
    
    private var isButtonDisabled: Bool {
        musicStore.authorizationStatus == .restricted ||
        (musicStore.isAuthorized && musicStore.isSubscribed)
    }
}

#Preview {
    AppleMusicAuthorizerView()
}
