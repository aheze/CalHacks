//
//  OriginView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

struct OriginView: View {
    @ObservedObject var model: ViewModel

    var body: some View {
        VStack {
            Text("P.M!")
                .font(.largeTitle)
                .scaleEffect(model.entered ? 0.5 : 1)
                .opacity(model.entered ? 0 : 1)
                .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1).delay(0.4), value: model.entered)

            Spacer()

            Button {
                model.entered = true
            } label: {
                Text("Play")
                    .textCase(.uppercase)
                    .font(.title)
                    .foregroundColor(.green)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background {
                        Capsule()
                            .fill(Color.white)
                    }
            }
            .scaleEffect(model.entered ? 0.5 : 1)
            .opacity(model.entered ? 0 : 1)
            .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 1).delay(0.1), value: model.entered)
        }
        .fontWeight(.black)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 32)
        .background {
            Color.green
                .mask(SlantShape(brOffset: 40))
                .padding(.bottom, -40)
                .ignoresSafeArea()
                .offset(y: model.entered ? -1000 : 0)
                .animation(.spring(response: 0.8, dampingFraction: 1, blendDuration: 1), value: model.entered)
        }
    }
}
