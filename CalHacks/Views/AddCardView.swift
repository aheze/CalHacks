//
//  AddCardView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

struct AddCardView: View {
    @ObservedObject var model: ViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Text("Add Card")
                    .font(.largeTitle)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(width: 42, height: 42)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .opacity(0.15)
                        )
                }
            }

            Button {} label: {
                VStack(spacing: 12) {
                    VStack(spacing: 24) {
                        Image(systemName: "camera.fill")

                        Text("Scan with Camera")
                            .textCase(.uppercase)
                    }
                    .font(.title)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        UIColor.systemTeal.color,
                                        UIColor.systemTeal.offset(by: -0.2).color
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .brightness(-0.1)
                    }
                    
                    Text("Scan a 3D object from the real world!")
                        .font(.body)
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background {
            Color.black
                .brightness(0.1)
                .ignoresSafeArea()
        }
    }
}
