//
//  ThanksView.swift
//  MusicGirl
//
//  Created by mio kato on 2025/07/13.
//

import SwiftUI

struct ThanksView: View {
    let text: LocalizedStringKey
    
    var body: some View {
        Section {
            HStack {
                Text(text)
                Image(systemName: "sparkles")
                    .foregroundStyle(.yellow)
            }
        }
    }
}

#Preview {
    Form {
        ThanksView(text: "ご支援ありがとうございます")
    }
}
