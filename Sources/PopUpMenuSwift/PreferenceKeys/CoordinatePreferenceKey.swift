//
//  CoordinatePreferenceKey.swift
//
//
//  Created by Dmitry Kononchuk on 08.03.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

// MARK: - PreferenceKey
private struct CoordinatePreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

// MARK: - Ext. View modifier
extension View {
    func coordinateOfView(onChange: @escaping (CGPoint) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: CoordinatePreferenceKey.self,
                        value: geometry.frame(in: .global).midPoint
                    )
            }
        )
        .onPreferenceChange(CoordinatePreferenceKey.self, perform: onChange)
    }
}

// MARK: - Ext. CGRect
private extension CGRect {
    var midPoint: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }
}
