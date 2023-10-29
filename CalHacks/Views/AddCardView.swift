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
    @State var shown = false

    @State var loading = false
    @State var isPresented = false

    var body: some View {
        VStack(spacing: 36) {
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

                Button {
                    withAnimation {
                        loading = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isPresented = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            loading = false
                        }
                    }
                } label: {
                    VStack(spacing: 24) {
                        Image(systemName: "camera.fill")
                            .opacity(loading ? 0 : 1)
                            .overlay {
                                ProgressView()
                                    .controlSize(.large)
                                    .opacity(loading ? 1 : 0)
                                    .environment(\.colorScheme, .dark)
                            }

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
                                        UIColor.systemTeal.offset(by: 0.1).color
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .brightness(-0.1)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    Text("Card Store")
                        .font(.largeTitle)
                        .textCase(.uppercase)

                    ForEach(Array(zip(model.cardsStore.indices, model.cardsStore)), id: \.1.id) { index, card in
                        CardView(card: card)
                            .scaleEffect(shown ? 1 : 0.9)
                            .opacity(shown ? 1 : 0)
                            .animation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 1).delay(Double(index) * 0.1), value: shown)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
            .background {
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.white)
                    .opacity(0.1)
                    .padding(.bottom, -100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.black
                .brightness(0.1)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $isPresented) {
            ScanView(model: model)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                shown = true
            }
        }
    }
}
