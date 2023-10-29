//
//  ConfigView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/29/23.
//

import SwiftUI
import Files

struct ConfigView: View {
    @ObservedObject var model: ViewModel
    
    var body: some View {
        VStack {
            Text("Config")
                .font(.largeTitle)
                .textCase(.uppercase)
            
            FileExplorerView(folder: Folder.documents!)
        }
        .padding(.top, 32)
    }
}

struct FileExplorerView: View {
    var folder: Folder

    var body: some View {
        FileExplorerContentView(folder: folder, level: 1, expanded: true)
    }
}

struct FileExplorerContentView: View {
    var folder: Folder
    var level: Int
    @State var expanded = false

    var body: some View {
        VStack(spacing: 8) {
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    expanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Text(folder.name)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)

                    HStack(spacing: 8) {
                        Text("\(folder.subfolders.count() + folder.files.count())")
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.black)
                                    .opacity(0.2)
                            )

                        Image(systemName: "chevron.forward")
                            .rotationEffect(.degrees(expanded ? 90 : 0))
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .background(Color.green.brightness(-0.2))
                .cornerRadius(12)
            }

            if expanded {
                VStack(spacing: 8) {
                    if folder.subfolders.count() == 0 && folder.files.count() == 0 {
                        Text("Empty Folder")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(Color.green.opacity(0.25))
                            .cornerRadius(12)
                    }

                    ForEach(Array(folder.subfolders), id: \.name) { folder in
                        FileExplorerContentView(folder: folder, level: level + 1)
                    }

                    ForEach(Array(folder.files), id: \.name) { file in
                        Text(file.name)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(UIColor.black.color)
                            .cornerRadius(12)
                    }
                }
                .padding(.leading, CGFloat(level) * 16)
            }
        }
    }
}
