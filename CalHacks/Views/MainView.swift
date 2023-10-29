//
//  MainView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                switch model.selectedTab {
                case .cards:
                    CardsView(model: model)
                case .battle:
                    CardsView(model: model)
                case .config:
                    ConfigView(model: model)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(Color.black)
                    .brightness(0.3)
                    .frame(height: 2)
                
                HStack(spacing: 0) {
                    TabButton(title: "Cards", image: "Cards", selected: model.selectedTab == .cards) {
                        model.selectedTab = .cards
                    }
                    
                    Rectangle()
                        .foregroundColor(Color.black)
                        .brightness(0.3)
                        .frame(width: 2)
                        .ignoresSafeArea()
                    
                    TabButton(title: "Battle", image: "Swords", selected: model.selectedTab == .battle) {
                        model.selectedTab = .battle
                    }
                    
                    Rectangle()
                        .foregroundColor(Color.black)
                        .brightness(0.3)
                        .frame(width: 2)
                        .ignoresSafeArea()
                    
                    TabButton(title: "Config", image: "Gears", selected: model.selectedTab == .config) {
                        model.selectedTab = .config
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .offset(y: model.entered ? 0 : 200)
            .animation(.spring(response: 0.7, dampingFraction: 1, blendDuration: 1).delay(0.65), value: model.entered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scaleEffect(model.entered ? 1 : 1.2)
        .opacity(model.entered ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1).delay(0.5), value: model.entered)
        .background {
            Color.black
                .brightness(0.1)
                .ignoresSafeArea()
        }
    }
}

struct TabButton: View {
    var title: String
    var image: String
    var selected: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        } label: {
            VStack(spacing: 10) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(title)
                    .textCase(.uppercase)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .fontDesign(.monospaced)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .background {
                if selected {
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color.green
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .opacity(0.1)
                    .ignoresSafeArea()
                }
            }
            .contentShape(Rectangle())
        }
    }
}
