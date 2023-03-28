//
//  PopUpMenuView.swift
//
//
//  Created by Dmitry Kononchuk on 08.03.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

/// Show a popup menu view.
public struct PopUpMenuView: View {
    // MARK: - Property Wrappers
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.popUpStyle) private var popUpStyle
    
    @StateObject private var menuState = MenuState.shared
    
    @State private var anyViewSize: CGSize = .zero
    @State private var anyViewGlobalCoordinate: CGPoint = .zero
    @State private var popUpSize: CGSize = .zero
    @State private var isBouncePopUp = false
    @State private var popUpTimer: Timer?
    @State private var bounceTimer: Timer?
    @State private var orientation: UIDeviceOrientation = .unknown
    
    // MARK: - Private Properties
    private let menuIndex: Int
    private let anyView: AnyView
    private let menuItems: [String]
    private let textAlignment: TextAlignment
    private let fontName: String
    private let fontSize: CGFloat
    private let padding: CGFloat
    private let maxWidth: CGFloat
    private let popUpType: PopUpType
    private let popUpOffsetY: CGFloat
    private let isBounceAnimation: Bool
    private let isImpactFeedback: Bool
    private let zIndex: Double
    private let timeInterval: Double?
    private let completion: ((Int) -> Void)
    
    static private let popUpInsets = EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
    static private let strokeLineWidth: CGFloat = 0.9
    static private let bounce: CGFloat = 3
    
    // MARK: - Public Enums
    public enum PopUpType {
        case top
        case bottom
    }
    
    // MARK: - Private Enums
    private enum PopUpError: String {
        case noSpace = "Not enough space to show the popup"
    }
    
    // MARK: - body Property
    public var body: some View {
        ZStack {
            GeometryReader { geometry in
                if menuState.isShowMenu[menuIndex] {
                    ZStack {
                        PopUpStyle {
                            Group {
                                if let borderColor = popUpStyle.borderColor {
                                    PopUpShape(
                                        cornerRadius: popUpStyle.cornerRadius,
                                        arrowSize: popUpStyle.arrowSize,
                                        arrowMidX: getTriangleCoordinateX(geometry)
                                    )
                                    .overlay(
                                        PopUpShape(
                                            cornerRadius: popUpStyle.cornerRadius,
                                            arrowSize: popUpStyle.arrowSize,
                                            arrowMidX: getTriangleCoordinateX(geometry)
                                        )
                                        .stroke(
                                            borderColor,
                                            lineWidth: Self.strokeLineWidth
                                        )
                                    )
                                } else {
                                    PopUpShape(
                                        cornerRadius: popUpStyle.cornerRadius,
                                        arrowSize: popUpStyle.arrowSize,
                                        arrowMidX: getTriangleCoordinateX(geometry)
                                    )
                                }
                            }
                            .rotation3DEffect(
                                .degrees(popUpType == .top ? 0 : 180),
                                axis: (x: 1, y: 0, z: 0)
                            )
                            .opacity(popUpStyle.opacity)
                            .shadow(
                                color: popUpStyle.shadowColor?
                                    .opacity(popUpStyle.shadowOpacity) ?? .clear,
                                radius: popUpStyle.shadowRadius,
                                x: popUpStyle.shadowOffset.x,
                                y: popUpStyle.shadowOffset.y
                            )
                            .blur(radius: popUpStyle.blurRadius)
                        }
                        
                        ScrollView {
                            ForEach(Array(menuItems.enumerated()), id: \.element) { index, item in
                                DropdownButtonView(
                                    text: item,
                                    textColor: popUpStyle.textColor,
                                    fontName: fontName,
                                    fontSize: fontSize,
                                    textAlignment: textAlignment,
                                    backgroundColor: popUpStyle.itemBackgroundColor,
                                    cornerRadius: popUpStyle.itemCornerRadius,
                                    padding: popUpStyle.itemPadding
                                ) {
                                    menuState.clearState()
                                    startOrStopPopUpTimer()
                                    stopBounceTimerIfNeeded()
                                    createImpactFeedbackIfNeeded()
                                    completion(index)
                                }
                            }
                            .sizeOfView { size in
                                popUpSize = size
                            }
                            .frame(width: maxWidth)
                            .frame(maxWidth: popUpSize.width)
                            .padding(padding)
                        }
                        .simultaneousGesture(
                            DragGesture()
                                .onChanged { _ in
                                    if isPopUpNotInScreenFrame() {
                                        startOrStopPopUpTimer()
                                        
                                        if isBounceAnimation {
                                            isBouncePopUp = false
                                            startBounceTimer()
                                        }
                                    }
                                }
                        )
                    }
                    .transition(.popUpTransition())
                    .position(
                        x: getRectangleCoordinateX(geometry),
                        y: getRectangleCoordinateY(geometry)
                    )
                    .offset(y: isBouncePopUp ? getBounceOffset() : 0)
                    .animation(
                        isBouncePopUp
                        ? .linear(duration: 0.4)
                            .repeatForever(autoreverses: true)
                        : .easeInOut,
                        value: isBouncePopUp
                    )
                }
                
                anyView
                    .disabled(true)
                    .sizeOfView { size in
                        anyViewSize = size
                    }
                    .fixedSize()
                    .position(
                        x: geometry.size.width * 0.5,
                        y: geometry.size.height * 0.5
                    )
                    .coordinateOfView { coordinate in
                        anyViewGlobalCoordinate = coordinate
                    }
                    .onTapGesture {
                        if isEnoughSpaceToPopup() {
                            menuState.updateState(with: menuIndex)
                            startOrStopPopUpTimer()
                            stopBounceTimerIfNeeded()
                        } else {
                            print("**** \(PopUpMenuView.self) error: \(PopUpError.noSpace.rawValue) \(popUpType).")
                        }
                    }
            }
            .frame(
                width: popUpSize.width + padding * 2,
                height: abs(getPopUpHeight())
            )
        }
        .frame(width: anyViewSize.width, height: anyViewSize.height)
        .zIndex(zIndex)
        .onChange(of: menuState.isShowMenu[menuIndex]) { newValue in
            if newValue {
                createImpactFeedbackIfNeeded()
            } else {
                stopPopUpTimerIfNeeded()
                stopBounceTimerIfNeeded()
            }
            
            guard isBounceAnimation else { return }
            
            DispatchQueue.main.async {
                isBouncePopUp = newValue
            }
        }
        .onRotate { newOrientation in
            // Required for floating animation to work
            // when rotated on iOS 15.0 and above.
            orientation = newOrientation
        }
    }
    
    // MARK: - Initializers
    /// - Parameters:
    ///   - anyView: Any view to be displayed.
    ///   - menuItems: The dropdown list items.
    ///   - textAlignment: Text alignment.
    ///   - fontName: Font name.
    ///   - fontSize: Font size.
    ///   - padding: Text padding.
    ///   - maxWidth: Maximum width that the popup can take.
    ///   - popUpType: Popup opening type.
    ///   - popUpOffsetY: Popup offset y position.
    ///   - isBounceAnimation: Set to `true` for bouncing animation of the popup.
    ///   - isImpactFeedback: Set to `false` to disable haptics to simulate physical impacts.
    ///   - zIndex: Controls the display order of overlapping views.
    ///   - timeInterval: Time interval for the popup to be visible.
    public init(
        anyView: AnyView,
        menuItems: [String],
        textAlignment: TextAlignment = .center,
        fontName: String = "Seravek",
        fontSize: CGFloat = 16,
        padding: CGFloat = 8,
        maxWidth: CGFloat = 240,
        popUpType: PopUpType = .top,
        popUpOffsetY: CGFloat = 6,
        isBounceAnimation: Bool = false,
        isImpactFeedback: Bool = true,
        zIndex: Double = .zero,
        timeInterval: Double? = nil,
        completion: @escaping ((Int) -> Void)
    ) {
        UIScrollView.appearance().bounces = false
        menuIndex = MenuState.shared.setState()
        
        self.anyView = anyView
        self.menuItems = menuItems
        self.textAlignment = textAlignment
        self.fontName = fontName
        self.fontSize = fontSize
        self.padding = padding
        self.maxWidth = maxWidth
        self.popUpType = popUpType
        self.popUpOffsetY = popUpOffsetY
        self.isBounceAnimation = isBounceAnimation
        self.isImpactFeedback = isImpactFeedback
        self.zIndex = zIndex
        self.timeInterval = timeInterval
        self.completion = completion
    }
    
    // MARK: - Private Methods
    private func getTriangleCoordinateX(_ geometry: GeometryProxy) -> CGFloat {
        if geometry.frame(in: .global).maxX > UIWindow.screenSize.width {
            return geometry.size.width * 0.5 -
            (UIWindow.screenSize.width - geometry.frame(in: .global).maxX) +
            Self.popUpInsets.trailing
        }
        
        if geometry.frame(in: .global).minX < .zero {
            return geometry.size.width * 0.5 +
            geometry.frame(in: .global).minX -
            Self.popUpInsets.leading
        }
        
        return geometry.size.width * 0.5
    }
    
    private func getRectangleCoordinateX(_ geometry: GeometryProxy) -> CGFloat {
        if geometry.frame(in: .global).maxX > UIWindow.screenSize.width {
            return geometry.size.width * 0.5 +
            (UIWindow.screenSize.width - geometry.frame(in: .global).maxX) -
            Self.popUpInsets.trailing
        }
        
        if geometry.frame(in: .global).minX < .zero {
            return geometry.size.width * 0.5 -
            geometry.frame(in: .global).minX +
            Self.popUpInsets.leading
        }
        
        return geometry.size.width * 0.5
    }
    
    private func getRectangleCoordinateY(_ geometry: GeometryProxy) -> CGFloat {
        if isPopUpTop() {
            return geometry.frame(in: .local).minY - popUpStyle.arrowSize.height -
            anyViewSize.height * 0.5 - popUpOffsetY
        }
        
        return geometry.frame(in: .local).maxY + popUpStyle.arrowSize.height +
        anyViewSize.height * 0.5 + popUpOffsetY
    }
    
    private func getPopUpHeight() -> CGFloat {
        let height: CGFloat
        
        if isPopUpNotInScreenFrame() {
            let popUpYPosition = getPopUpYPosition()
            
            if isPopUpTop() {
                height = popUpYPosition + popUpSize.height +
                padding * 2 - Self.popUpInsets.top - getBounce()
            } else {
                height = popUpYPosition - UIWindow.screenSize.height -
                popUpSize.height - padding * 2 + Self.popUpInsets.bottom + getBounce()
            }
        } else {
            height = popUpSize.height + padding * 2
        }
        
        return height
    }
    
    private func isPopUpNotInScreenFrame() -> Bool {
        if isPopUpTop() {
            return getPopUpYPosition() < .zero
        }
        
        return getPopUpYPosition() > UIWindow.screenSize.height
    }
    
    private func getPopUpYPosition() -> CGFloat {
        if isPopUpTop() {
            let popUpMinYPosition = anyViewGlobalCoordinate.y - safeAreaInsets.top -
            anyViewSize.height * 0.5 - popUpSize.height -
            popUpOffsetY - popUpStyle.arrowSize.height - padding * 2
            
            return popUpMinYPosition
        }
        
        let popUpMaxYPosition = anyViewGlobalCoordinate.y + safeAreaInsets.bottom +
        anyViewSize.height * 0.5 + popUpSize.height +
        popUpOffsetY + popUpStyle.arrowSize.height + padding * 2
        
        return popUpMaxYPosition
    }
    
    private func isEnoughSpaceToPopup() -> Bool {
        if isPopUpTop() {
            let popUpMaxYPosition = anyViewGlobalCoordinate.y - anyViewSize.height * 0.5 -
            popUpOffsetY - popUpStyle.arrowSize.height -
            Self.popUpInsets.top - getBounce()
            
            return popUpMaxYPosition > safeAreaInsets.top
        }
        
        let popUpMinYPosition = anyViewGlobalCoordinate.y + anyViewSize.height * 0.5 +
        popUpOffsetY + popUpStyle.arrowSize.height +
        Self.popUpInsets.bottom + getBounce()
        
        return popUpMinYPosition < UIWindow.screenSize.height - safeAreaInsets.bottom
    }
    
    private func getBounceOffset() -> CGFloat {
        popUpType == .top ? -Self.bounce : Self.bounce
    }
    
    private func getBounce() -> CGFloat {
        isBounceAnimation ? Self.bounce : .zero
    }
    
    private func isPopUpTop() -> Bool {
        popUpType == .top
    }
    
    private func startBounceTimer() {
        stopBounceTimerIfNeeded()
        
        if !isBouncePopUp {
            bounceTimer = Timer.scheduledTimer(
                withTimeInterval: 8,
                repeats: false
            ) { _ in
                isBouncePopUp.toggle()
            }
        }
    }
    
    private func stopBounceTimerIfNeeded() {
        guard isBounceAnimation else { return }
        
        if let runningTimer = bounceTimer {
            runningTimer.invalidate()
            bounceTimer = nil
        }
    }
    
    private func startOrStopPopUpTimer() {
        guard let timeInterval = timeInterval else { return }
        
        stopPopUpTimerIfNeeded()
        
        if menuState.isShowMenu[menuIndex] {
            popUpTimer = Timer.scheduledTimer(
                withTimeInterval: timeInterval,
                repeats: false
            ) { _ in
                menuState.clearState()
            }
        }
    }
    
    private func stopPopUpTimerIfNeeded() {
        if let runningTimer = popUpTimer {
            runningTimer.invalidate()
            popUpTimer = nil
        }
    }
    
    private func createImpactFeedbackIfNeeded() {
        if isImpactFeedback {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
}
