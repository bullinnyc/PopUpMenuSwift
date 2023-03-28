//
//  PopUpShape.swift
//
//
//  Created by Dmitry Kononchuk on 08.03.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct PopUpShape: Shape {
    // MARK: - Public Properties
    let cornerRadius: CGFloat
    let arrowSize: CGSize
    let arrowMidX: CGFloat
    
    // MARK: - Public Methods
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Middle up.
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        
        // Right upper corner.
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        
        // Upper right arc.
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        
        // Bottom right corner.
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        
        // Bottom right arc.
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        
        // Arrow.
        path.addLine(to: CGPoint(x: arrowMidX + arrowSize.width * 0.5, y: rect.maxY))
        path.addLine(to: CGPoint(x: arrowMidX, y: rect.maxY + arrowSize.height))
        path.addLine(to: CGPoint(x: arrowMidX - arrowSize.width * 0.5, y: rect.maxY))
        
        // Bottom left corner.
        path.addLine(to: CGPoint(x:rect.minX + cornerRadius, y: rect.maxY))
        
        // Bottom left arc.
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        
        // Left upper corner.
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        // Upper left arc.
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}
