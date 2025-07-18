//
//  TipView.swift
//  MusicGirl
//
//  Created by mio kato on 2025/07/13.
//

import SwiftUI
import StoreKit

struct TipView: View {
    let product: Product?
    
    var onTapButton: (Product) -> Void
    
    var body: some View {
        Section {
            Text("Development support")
                .font(.title2).bold()
            Text("If you enjoy the app, we’d be grateful for your support — even just the price of a cup of coffee ☕️")
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
            HStack {
                Text("Support")
                Spacer()
                if let product = product {
                    Button(
                        product.displayPrice,
                        action: { onTapButton(product) }
                    )
                } else {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    Form {
        TipView(product: nil, onTapButton: { _ in })
    }
}
