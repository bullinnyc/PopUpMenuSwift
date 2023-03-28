//
//  DropdownButtonView.swift
//
//
//  Created by Dmitry Kononchuk on 08.03.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct DropdownButtonView: View {
    // MARK: - Public Properties
    let text: String
    let textColor: Color
    let fontName: String
    let fontSize: CGFloat
    let textAlignment: TextAlignment
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let padding: CGFloat
    let action: () -> Void
    
    // MARK: - body Property
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.custom(fontName, size: fontSize))
                .multilineTextAlignment(textAlignment)
                .foregroundColor(textColor)
                .frame(
                    maxWidth: .infinity,
                    alignment: textAlignment.toAlignment()
                )
                .padding(padding)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview Provider
struct DropdownButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownButtonView(
            text: "Some text",
            textColor: .white,
            fontName: "Seravek",
            fontSize: 22,
            textAlignment: .leading,
            backgroundColor: .pink,
            cornerRadius: 4,
            padding: 8
        ) {}
    }
}
