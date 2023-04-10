//
//  PopUpTransitionViewModifier.swift
//  
//
//  Created by Dmitry Kononchuk on 10.04.2023.
//

import SwiftUI

private struct PopUpTransitionViewModifier: ViewModifier {
    // MARK: - Public Properties
    let isAnimation: Bool
    
    // MARK: - body Method
    func body(content: Content) -> some View {
        if isAnimation {
            content
                .transition(.popUpTransition())
        } else {
            content
        }
    }
}

// MARK: - Ext. View
extension View {
    func popUpTransition(isAnimation: Bool) -> some View {
        modifier(PopUpTransitionViewModifier(isAnimation: isAnimation))
    }
}
