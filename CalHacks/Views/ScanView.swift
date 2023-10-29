//
//  ScanView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/29/23.
//

import Files
import RealityKit
import SwiftUI



struct ScanView: View {
    @ObservedObject var model: ViewModel
    @Environment(\.dismiss) var dismiss

    @StateObject var scanViewModel = ScanViewModel()
    @State var started = false

    var body: some View {
        let finished = scanViewModel.session?.userCompletedScanPass ?? false

        ZStack {
            ProgressView()
                .controlSize(.extraLarge)
                .environment(\.colorScheme, .dark)

            if started && !scanViewModel.finished {
                CapturePrimaryView(scanViewModel: scanViewModel)
            }

            if scanViewModel.finished {
                ReconstructionProgressView(model: model, scanViewModel: scanViewModel, outputFile: scanViewModel.outputFile)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.black
                .ignoresSafeArea()
        }
        .overlay {
            VStack {
                if let session = scanViewModel.session, session.userCompletedScanPass {
                    VStack(spacing: 20) {
                        if let session = scanViewModel.session {
                            ObjectCapturePointCloudView(session: session)
                                .frame(height: 100)
                        }

                        Text("Completed!")
                            .font(.largeTitle)

                        Button {
                            scanViewModel.finishScan()
                        } label: {
                            Text("Next")
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background {
                                    Color.green
                                        .brightness(-0.1)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 16)
                                        }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        ZStack {
                            VisualEffectView(.systemUltraThinMaterialDark)
                            Color.black
                                .opacity(0.5)
                        }
                        .ignoresSafeArea()
                    }
                }
            }
        }
        .overlay(alignment: .top) {
            let showReset = switch scanViewModel.session?.state {
            case .initializing, .ready, .none:
                false
            default:
                true
            }

            HStack(spacing: 12) {
                HStack(spacing: 12) {
                    if showReset {
                        Button {
                            scanViewModel.session?.resetDetection()
                            scanViewModel.session = nil
                            scanViewModel.start()
                        } label: {
                            Text("Reset")
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background {
                                    VisualEffectView(.systemChromeMaterialDark)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 16)
                                        }
                                }
                        }
                        .geometryGroup()
                    }

                    let string: String? = switch scanViewModel.session?.state {
                    case .initializing:
                        "Loading..."
                    case .ready:
                        "Start Detecting"
                    case .detecting:
                        "Start Capture"
                    case .capturing:
                        "Capturing..."
                    case .finishing:
                        "Finishing..."
                    case .completed:
                        "Completed!"
                    case .failed(let error):
                        "Fail: \(error)"
                    default:
                        nil
                    }

                    if let string {
                        Button {
                            switch scanViewModel.session?.state {
                            case .initializing:
                                break
                            case .ready:
                                let detection = scanViewModel.session?.startDetecting()
                                print("detection? \(detection)")
                            case .detecting:
                                scanViewModel.session?.startCapturing()
                            case .capturing:
                                break
                            case .finishing:
                                break
                            case .completed:
                                break
                            case .failed(let error):
                                break
                            default:
                                break
                            }
                        } label: {
                            Text(string)
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background {
                                    Color.green
                                        .brightness(-0.1)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 16)
                                        }
                                }
                        }
                        .geometryGroup()
                    }
                }
                .opacity(finished ? 0.5 : 1)
                .disabled(finished)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(width: 42, height: 42)
                        .background(
                            VisualEffectView(.regular)
                                .mask {
                                    Circle()
                                }
                        )
                }
                .padding(20)
            }
            .animation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 1), value: showReset)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background {
                VisualEffectView(.systemThinMaterialDark)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                started = true
                scanViewModel.start()
            }
        }
    }
}

struct CapturePrimaryView: View {
    @ObservedObject var scanViewModel: ScanViewModel

    var body: some View {
        if let session = scanViewModel.session {
            ObjectCaptureView(session: session)
        } else {
            Text("Loading session...")
                .foregroundStyle(.green)
                .offset(y: 60)
        }
    }
}
