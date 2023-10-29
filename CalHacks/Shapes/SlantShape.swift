//
//  SlantShape.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

struct SlantShape: Shape {
    var tlOffset = CGFloat(0)
    var trOffset = CGFloat(0)
    var blOffset = CGFloat(0)
    var brOffset = CGFloat(0)
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: tlOffset))
            path.addLine(to: CGPoint(x: rect.maxX, y: trOffset))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - brOffset))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - blOffset))
            path.addLine(to: CGPoint(x: rect.minX, y: tlOffset))
        }
    }
}

#Preview {
    SlantShape(tlOffset: 0, trOffset: 20, blOffset: 20, brOffset: 20)
        .frame(width: 100, height: 120)
}

