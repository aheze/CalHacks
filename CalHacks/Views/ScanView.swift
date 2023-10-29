//
//  ScanView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/29/23.
//

import Files
import Foundation
import RealityKit
import SwiftUI

@MainActor class ScanViewModel: ObservableObject {
    @Published var session: ObjectCaptureSession?

    
    func reset() {
        print("Resetting!")
        
        if let folder = try? Folder.documents!.subfolder(named: "Snapshots") {
            for file in folder.files {
                try? file.delete()
            }
        } else {
            print("No subfolder!")
        }

        if let folder = try? Folder.documents!.subfolder(named: "Images") {
            for file in folder.files {
                try? file.delete()
            }
        } else {
            print("No subfolder images!")
        }
    }
    func start() {
        reset()
        var configuration = ObjectCaptureSession.Configuration()
        configuration.checkpointDirectory = Folder.documents!.url.appendingPathComponent("Snapshots/")

        let session = ObjectCaptureSession()
        session.start(imagesDirectory: Folder.documents!.url.appendingPathComponent("Images/"),
                      configuration: configuration)
        self.session = session

//        Task {
//            for await update in session.stateUpdates {
//                print("UPdate: \(update)")
//
//                if case .failed(let error) = update {
//                    print("Failed!")
//                    self.reset()
//                    self.session = nil
//                    self.session = ObjectCaptureSession()
//                }
//            }
//            
//            for await update in session.feedbackUpdates {
//                print("Up: \(update)")
//            }
//        }
    }
}

struct ScanView: View {
    @ObservedObject var model: ViewModel
    @Environment(\.dismiss) var dismiss

    @StateObject var scanViewModel = ScanViewModel()
    @State var started = false

    var body: some View {
        ZStack {
            ProgressView()
                .controlSize(.extraLarge)
                .environment(\.colorScheme, .dark)

//            if started {
            CapturePrimaryView(scanViewModel: scanViewModel)
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.black
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            let showReset = switch scanViewModel.session?.state {
            case .initializing, .ready, .none:
                    false
                default:
                    true
            }

            HStack(spacing: 12) {
                if showReset {
                    Button {
                        scanViewModel.session?.resetDetection()
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
                }

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
                    let string: String = switch scanViewModel.session?.state {
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
                            ""
                    }

                    Text(string)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background {
                            VisualEffectView(.systemThickMaterialDark)
                                .mask {
                                    RoundedRectangle(cornerRadius: 16)
                                }
                        }
                }
                
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
            Text("No session")
                .foregroundStyle(.red)
        }
    }
}
