//
//  Extension + AnyTransition.swift
//
//
//  Created by Dmitry Kononchuk on 08.03.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    // MARK: - Public Methods
    static func popUpTransition() -> AnyTransition {
        let insertion = AnyTransition.opacity
            .combined(with: .scale)
            .animation(.spring().speed(1.5))
        
        let removal = AnyTransition.opacity
            .animation(.easeOut(duration: 0.21))
        
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
