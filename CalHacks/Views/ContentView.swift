//
//  ContentView.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

// P.M!

struct ContentView: View {
    @ObservedObject var model: ViewModel

    var body: some View {
        ZStack {
            MainView(model: model)
            
            OriginView(model: model)
                .disabled(model.entered)
            
            
            
//            Image(systemName: "figure.run.circle.fill")
//                .font(.system(size: 300))
//                .colorEffect(ShaderLibrary.checkerboard(.float(10), .color(.blue)))
//                .colorEffect(ShaderLibrary.checker)
        }
        .transition(.opacity)
    }
}


//struct ContentView: View {
//    @ObservedObject var model: ViewModel
//    
//    let startDate = Date()
//
//    var body: some View {
//        TimelineView(.animation) { context in
//            Image(systemName: "figure.run.circle.fill")
//                .font(.system(size: 300))
//                .layerEffect(ShaderLibrary.pixellate(.float(10)), maxSampleOffset: .zero)
//
////                .colorEffect(ShaderLibrary.noise(.float(startDate.timeIntervalSinceNow)))
//        }
//    }
//}
