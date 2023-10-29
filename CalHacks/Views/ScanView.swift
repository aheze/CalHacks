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

    let snapshotsFolder = try! Folder.documents!.createSubfolderIfNeeded(withName: "Snapshots")
    let imagesFolder = try! Folder.documents!.createSubfolderIfNeeded(withName: "Images")

    func resetFolders() {
        print("Resetting!")

        for file in snapshotsFolder.files {
            do {
                try file.delete()
            } catch {
                print("Error deleting snap file: \(error)")
            }
        }
        
        for folder in snapshotsFolder.subfolders {
            do {
                try folder.delete()
            } catch {
                print("Error deleting snap folder: \(error)")
            }
        }

        for file in imagesFolder.files {
            do {
                try file.delete()
            } catch {
                print("Error deleting image file: \(error)")
            }
        }
        
        for folder in imagesFolder.subfolders {
            do {
                try folder.delete()
            } catch {
                print("Error deleting image folder: \(error)")
            }
        }
    }

    func start() {
        resetFolders()
        
        print("snapshotsFolder: \(snapshotsFolder.files.count())")

        var configuration = ObjectCaptureSession.Configuration()
        configuration.checkpointDirectory = snapshotsFolder.url

        print("Created config")
        let session = ObjectCaptureSession()

        print("Created session")
        session.start(
            imagesDirectory: imagesFolder.url,
            configuration: configuration
        )

        print("Started session")
        self.session = session

        print("Set session!")

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
        .overlay {
            VStack {
                if scanViewModel.session?.userCompletedScanPass ?? false {
                    Text("Completed!")
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
