//
//  ContentView.swift
//
//
//  Created by Dmitry Kononchuk on 08.03.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

#if os(iOS)
import SwiftUI
import PopUpMenuSwift

struct ContentView: View {
    // MARK: - Private Properties
    private let menuItems = [
        "First item. Do something on tapped on the item.",
        "Second item",
        "Third item",
        "Fourth item",
        "Fifth item"
    ]
    
    // MARK: - body Property
    var body: some View {
        let firstMenuView = createTextView(
            "Light style",
            foregroundColor: .black,
            backgroundColor: .white
        )
        
        let secondMenuView = createTextView(
            "Dark style",
            foregroundColor: .white,
            backgroundColor: .black
        )
        
        let thirdMenuView = createTextView(
            "Custom style",
            foregroundColor: .white,
            backgroundColor: .pink
        )
        
        let fourthMenuView = createTextView(
            "Custom style with bouncing",
            foregroundColor: .white,
            backgroundColor: Color(theia)
        )
        
        ZStack {
            Color(venus).opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    // PopUp with light style (default).
                    PopUpMenuView(
                        anyView: firstMenuView,
                        menuItems: menuItems
                    ) { index in
                        print("Dropdown index: \(index)")
                    }
                    
                    // PopUp with dark style.
                    PopUpMenuView(
                        anyView: secondMenuView,
                        menuItems: menuItems
                    ) { index in
                        print("Dropdown index: \(index)")
                    }
                    .popUpMenuStyle(.darkStyle)
                    
                    // PopUp with custom style.
                    PopUpMenuView(
                        anyView: thirdMenuView,
                        menuItems: menuItems
                    ) { index in
                        print("Dropdown index: \(index)")
                    }
                    .popUpMenuStyle(
                        .customStyle(
                            textColor: .white,
                            itemBackgroundColor: .pink,
                            backgroundColor: .pink.opacity(0.5)
                        )
                    )
                }
                
                // PopUp with custom style.
                PopUpMenuView(
                    anyView: fourthMenuView,
                    menuItems: menuItems,
                    popUpType: .bottom,
                    isBounceAnimation: true
                ) { index in
                    print("Dropdown index: \(index)")
                }
                .popUpMenuStyle(
                    .customStyle(
                        textColor: .white,
                        itemBackgroundColor: Color(theia),
                        backgroundColor: Color(theia).opacity(0.5)
                    )
                )
            }
        }
        .statusBar(hidden: true)
    }
    
    // MARK: - Private Properties
    private func createTextView(
        _ text: String,
        foregroundColor: Color,
        backgroundColor: Color
    ) -> some View {
        Text(text)
            .foregroundColor(foregroundColor)
            .font(.custom("Seravek", size: 18))
            .padding(8)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
