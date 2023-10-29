//
//  CardsView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

struct CardsView: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack {
            Text("Cards")
                .font(.largeTitle)
                .textCase(.uppercase)
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(model.cards) { card in
                        CardView(card: card)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .safeAreaInset(edge: .bottom) {
                Button {} label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background {
                            VisualEffectView(.regular)
                                .mask {
                                    Circle()
                                }
                                .shadow(color: .black.opacity(0.5), radius: 16, x: 0, y: 16)
                        }
                }
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
        }
        .padding(.top, 32)
    }
}

struct CardView: View {
    var card: Card
    
    var body: some View {
        let color = UIColor(hexString: card.backgroundColor) ?? .systemRed
        let color2 = color.offset(by: -0.1)
        let color3 = color.offset(by: 0.05)
        
        VStack(spacing: 0) {
            Color.clear
                .frame(height: 200)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.color, lineWidth: 10)
                        .brightness(0.2)
                }
                .padding(.bottom, -32)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(card.title)
                    .font(.title)
                    .textCase(.uppercase)
                
                Text(card.description)
                    .font(.title3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
            .background {
                LinearGradient(
                    colors: [
                        color.color,
                        color3.color
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .brightness(-0.15)
                .mask {
                    SlantShape(tlOffset: 32)
                }
                .shadow(color: .white.opacity(0.2), radius: 24, x: 0, y: 0)
                .padding(.top, -32)
            }
        }
        .background {
            LinearGradient(
                colors: [
                    color.color,
                    color2.color
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .mask {
            RoundedRectangle(cornerRadius: 16)
        }
    }
}
