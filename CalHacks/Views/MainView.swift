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
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Rectangle()
                .foregroundColor(Color.black)
                .brightness(0.3)
                .frame(height: 2)
            
            HStack(spacing: 0) {
                TabButton(title: "Cards", image: "Cards") {
                    
                }
                
                Rectangle()
                    .foregroundColor(Color.black)
                    .brightness(0.3)
                    .frame(width: 2)
                    .ignoresSafeArea()
                
                TabButton(title: "Battle", image: "Swords") {
                    
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scaleEffect(model.entered ? 1 : 1.2)
        .opacity(model.entered ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1).delay(0.5), value: model.entered)
        .background {
            Color.black
                .brightness(0.2)
                .ignoresSafeArea()
        }
    }
}

struct TabButton: View {
    var title: String
    var image: String
    var action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Text(title)
                    .textCase(.uppercase)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .fontDesign(.monospaced)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .contentShape(Rectangle())
        }
    }
}
