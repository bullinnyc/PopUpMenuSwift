//
//  MenuState.swift
//
//
//  Created by Dmitry Kononchuk on 08.03.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation

class MenuState: ObservableObject {
    // MARK: - Property Wrappers
    @Published var isShowMenu: [Bool] = []
    
    // MARK: - Public Properties
    static let shared = MenuState()
    
    // MARK: - Private Properties
    private var menuCounter = 0
    private var currentOpenMenu: Int!
    
    // MARK: - Private Initializers
    private init() {}
    
    // MARK: - Public Methods
    func setState() -> Int {
        menuCounter += 1
        isShowMenu = Array(repeating: false, count: menuCounter)
        
        return getMenuIndex()
    }
    
    func updateState(with menuIndex: Int) {
        let isCurrentMenu = isCurrentMenu(menuIndex)
        
        var newValue = Array(repeating: false, count: isShowMenu.count)
        newValue[menuIndex] = !isCurrentMenu
        
        currentOpenMenu = isCurrentMenu ? nil : menuIndex
        isShowMenu = newValue
    }
    
    func clearState() {
        isShowMenu[currentOpenMenu] = false
        currentOpenMenu = nil
    }
    
    // MARK: - Private Methods
    private func getMenuIndex() -> Int {
        menuCounter - 1
    }
    
    private func isCurrentMenu(_ index: Int) -> Bool {
        currentOpenMenu == index
    }
}
