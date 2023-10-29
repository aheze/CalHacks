//
//  ScanViewModel.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/29/23.
//

import Combine
import Files
import RealityKit
import SwiftUI

let snapshotsFolder = try! Folder.documents!.createSubfolderIfNeeded(withName: "Snapshots")
let imagesFolder = try! Folder.documents!.createSubfolderIfNeeded(withName: "Images")
let modelsFolder = try! Folder.documents!.createSubfolderIfNeeded(withName: "Models")

@MainActor class ScanViewModel: ObservableObject {
    @Published var session: ObjectCaptureSession?
    @Published var finished = false

    @Published var photogrammetrySession: PhotogrammetrySession?
    @Published var filename = "\(UUID().uuidString).usdz"
    @Published var outputFile: URL!
    var processSession = PassthroughSubject<Void, Never>()

    init() {
        outputFile = modelsFolder.url.appendingPathComponent(filename)
    }

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

    func finishScan() {
        session?.finish()

        var configuration = PhotogrammetrySession.Configuration()
        configuration.checkpointDirectory = snapshotsFolder.url

        do {
            withAnimation {
                finished = true
            }

            let timer = TimeElapsed()
            print("Starting photogrammetrySession")
            photogrammetrySession = try PhotogrammetrySession(
                input: imagesFolder.url,
                configuration: configuration
            )
            print("Created sessino: \(timer)")
            
            processSession.send()

        } catch {
            print("Error: \(error)")
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
    }
}
