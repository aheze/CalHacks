//
//  ReconstructionProgressView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/29/23.
//

import RealityKit
import SwiftUI

struct ReconstructionProgressView: View {
    @ObservedObject var model: ViewModel
    @ObservedObject var scanViewModel: ScanViewModel

    let outputFile: URL
    @State var completed = false
    @State var cancelled = false
    

    @State private var progress: Float = 0
    @State private var estimatedRemainingTime: TimeInterval?
    @State private var processingStageDescription: String?
    @State private var pointCloud: PhotogrammetrySession.PointCloud?
    @State private var gotError: Bool = false
    @State private var error: Error?
    @State private var isCancelling: Bool = false

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var padding: CGFloat {
        horizontalSizeClass == .regular ? 60.0 : 24.0
    }

    private func isReconstructing() -> Bool {
        return !completed && !gotError && !cancelled
    }

    func restart() {}

    func view() {}

    var body: some View {
        VStack(spacing: 0) {
            if isReconstructing() {
                HStack {
                    Button {
                        print("Cancelling...")
                        isCancelling = true
                        scanViewModel.photogrammetrySession?.cancel()
                    } label: {
                        Text("Cancel (Object Reconstruction)")
                            .font(.headline)
                            .bold()
                            .padding(30)
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)

                    Spacer()
                }
            }

            Spacer()

            TitleView()

            Spacer()

            ProgressBarView(progress: progress,
                            estimatedRemainingTime: estimatedRemainingTime,
                            processingStageDescription: processingStageDescription)
                .padding(padding)

            Spacer()
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
        .alert(
            "Failed:  " + (error != nil ? "\(String(describing: error!))" : ""),
            isPresented: $gotError,
            actions: {
                Button("OK") {
                    print("Calling restart...")
                    restart()
                }
            },
            message: {}
        )
        .onReceive(scanViewModel.processSession) { _ in
            process()
        }
    }
    
    func process() {
        Task {
            guard let session = scanViewModel.photogrammetrySession else {
                print("NO session!''")
                return
            }

            let outputs = UntilProcessingCompleteFilter(input: session.outputs)

            do {
                try session.process(requests: [.modelFile(url: outputFile)])
            } catch {
                print("Processing the session failed!")
            }
            for await output in outputs {
                switch output {
                    case .inputComplete:
                        break
                    case .requestProgress(let request, fractionComplete: let fractionComplete):
                        if case .modelFile = request {
                            progress = Float(fractionComplete)
                        }
                    case .requestProgressInfo(let request, let progressInfo):
                        if case .modelFile = request {
                            estimatedRemainingTime = progressInfo.estimatedRemainingTime
                            processingStageDescription = progressInfo.processingStage?.processingStageString
                        }
                    case .requestComplete(let request, _):
                        switch request {
                            case .modelFile:
                                print("RequestComplete: .modelFile")
                            case .modelEntity(_, _), .bounds, .poses, .pointCloud:
                                // Not supported yet
                                break
                            @unknown default:
                                print("Received an output for an unknown request: \(String(describing: request))")
                        }
                    case .requestError(_, let requestError):
                        if !isCancelling {
                            gotError = true
                            error = requestError
                        }
                    case .processingComplete:
                        if !gotError {
                            completed = true
                            view()
                        }
                    case .processingCancelled:
                        cancelled = true
                        restart()
                    case .invalidSample(id: _, reason: _), .skippedSample(id: _), .automaticDownsampling:
                        continue
                    case .stitchingIncomplete:
                        break
                    @unknown default:
                        print("Received an unknown output: \(String(describing: output))")
                }
            }
            print(">>>>>>>>>> RECONSTRUCTION TASK EXIT >>>>>>>>>>>>>>>>>")
        }
    }
}

extension PhotogrammetrySession.Output.ProcessingStage {
    var processingStageString: String? {
        switch self {
            case .preProcessing:
                return "Pre-Processing (Reconstruction)"
            case .imageAlignment:
                return "Aligning Images (Reconstruction)"
            case .pointCloudGeneration:
                return "Generating Point Cloud (Reconstruction)"
            case .meshGeneration:
                return "Generating Mesh (Reconstruction)"
            case .textureMapping:
                return "Mapping Texture (Reconstruction)"
            case .optimization:
                return "Optimizing (Reconstruction)"
            default:
                return nil
        }
    }
}

private struct TitleView: View {
    var body: some View {
        Text(LocalizedString.processingTitle)
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    private enum LocalizedString {
        static let processingTitle = "Processing title (Object Capture)"
    }
}

struct ProgressBarView: View {
    // The progress value from 0 to 1 which describes how much coverage is done.
    var progress: Float
    var estimatedRemainingTime: TimeInterval?
    var processingStageDescription: String?

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var formattedEstimatedRemainingTime: String? {
        guard let estimatedRemainingTime = estimatedRemainingTime else { return nil }

        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: estimatedRemainingTime)
    }

    private var numOfImages: Int {
        guard let urls = try? FileManager.default.contentsOfDirectory(
            at: imagesFolder.url,
            includingPropertiesForKeys: nil
        ) else {
            return 0
        }
        return urls.filter { $0.pathExtension.uppercased() == "HEIC" }.count
    }

    var body: some View {
        VStack(spacing: 22) {
            VStack(spacing: 12) {
                HStack(spacing: 0) {
                    Text(processingStageDescription ?? LocalizedString.processing)

                    Spacer()

                    Text(progress, format: .percent.precision(.fractionLength(0)))
                        .bold()
                        .monospacedDigit()
                }
                .font(.body)

                ProgressView(value: progress)
            }

            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .center) {
                    Image(systemName: "photo")

                    Text(String(numOfImages))
                        .frame(alignment: .bottom)
                        .hidden()
                        .overlay {
                            Text(String(numOfImages))
                                .font(.caption)
                                .bold()
                        }
                }
                .font(.subheadline)
                .padding(.trailing, 16)

                VStack(alignment: .leading) {
                    Text(LocalizedString.processingModelDescription)

                    Text(String.localizedStringWithFormat(LocalizedString.estimatedRemainingTime,
                                                          formattedEstimatedRemainingTime ?? LocalizedString.calculating))
                }
                .font(.subheadline)
            }
            .foregroundColor(.secondary)
        }
    }

    private enum LocalizedString {
        static let processing = "Processing (Object Capture)"

        static let processingModelDescription = "Keep app running while processing. (Object Capture)"

        static let estimatedRemainingTime = "Estimated time remaining: %@ (Object Capture)"

        static let calculating = "Calculating… (Estimated time, Object Capture)"
    }
}

struct UntilProcessingCompleteFilter<Base>: AsyncSequence,
    AsyncIteratorProtocol where Base: AsyncSequence, Base.Element == PhotogrammetrySession.Output
{
    func makeAsyncIterator() -> UntilProcessingCompleteFilter {
        return self
    }

    typealias AsyncIterator = Self
    typealias Element = PhotogrammetrySession.Output

    private let inputSequence: Base
    private var completed: Bool = false
    private var iterator: Base.AsyncIterator

    init(input: Base) where Base.Element == Element {
        inputSequence = input
        iterator = inputSequence.makeAsyncIterator()
    }

    mutating func next() async -> Element? {
        if completed {
            return nil
        }

        guard let nextElement = try? await iterator.next() else {
            completed = true
            return nil
        }

        if case .processingComplete = nextElement {
            completed = true
        }
        if case .processingCancelled = nextElement {
            completed = true
        }

        return nextElement
    }
}
