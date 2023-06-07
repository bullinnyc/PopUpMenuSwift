//
//  PopUpStyle.swift
//
//
//  Created by Dmitry Kononchuk on 08.03.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

// MARK: - Style Protocol
public protocol PopUpStyleProtocol {
    var textColor: Color { get }
    var itemCornerRadius: CGFloat { get }
    var itemBackgroundColor: Color { get }
    var itemPadding: CGFloat { get }
    var backgroundColor: Color { get }
    var borderColor: Color? { get }
    var cornerRadius: CGFloat { get }
    var arrowSize: CGSize { get }
    var opacity: Double { get }
    var shadowColor: Color? { get }
    var shadowOpacity: Double { get }
    var shadowRadius: CGFloat { get }
    var shadowOffset: CGPoint { get }
    var blurRadius: CGFloat { get }
    
    associatedtype Body: View
    typealias Configuration = PopUpStyleConfiguration
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

// MARK: - Ext. Use style with static property
extension PopUpStyleProtocol where Self == CustomStyle {
    /// A popup with custom style.
    ///
    /// - Parameters:
    ///   - textColor: Menu item text color.
    ///   - itemBackgroundColor: Menu item background color.
    ///   - itemCornerRadius: Menu item corner radius.
    ///   - itemPadding: Menu item padding.
    ///   - backgroundColor: Popup background color.
    ///   - borderColor: Popup border color.
    ///   - cornerRadius: Popup corner radius.
    ///   - arrowSize: Popup arrow size.
    ///   - opacity: Popup opacity.
    ///   - shadowColor: Popup shadow color.
    ///   - shadowOpacity: Popup shadow opacity.
    ///   - shadowRadius: Popup shadow radius.
    ///   - shadowOffset: Popup shadow offset.
    ///   - blurRadius: Popup blur radius.
    public static func customStyle(
        textColor: Color,
        itemBackgroundColor: Color,
        itemCornerRadius: CGFloat = 4,
        itemPadding: CGFloat = 8,
        backgroundColor: Color,
        borderColor: Color? = nil,
        cornerRadius: CGFloat = 8,
        arrowSize: CGSize = CGSize(width: 8, height: 8),
        opacity: Double = 0.8,
        shadowColor: Color? = .black,
        shadowOpacity: Double = 0.4,
        shadowRadius: CGFloat = 10,
        shadowOffset: CGPoint = CGPoint(x: 2, y: 4),
        blurRadius: CGFloat = .zero
    ) -> CustomStyle {
        CustomStyle(
            textColor: textColor,
            itemBackgroundColor: itemBackgroundColor,
            itemCornerRadius: itemCornerRadius,
            itemPadding: itemPadding,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            cornerRadius: cornerRadius,
            arrowSize: arrowSize,
            opacity: opacity,
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            shadowRadius: shadowRadius,
            shadowOffset: shadowOffset,
            blurRadius: blurRadius
        )
    }
}

extension PopUpStyleProtocol where Self == DarkStyle {
    /// A popup with dark style.
    public static var darkStyle: DarkStyle { DarkStyle() }
}

// MARK: - Style Content
struct PopUpStyle<Content: View>: View {
    @Environment(\.popUpStyle) private var style
    let content: () -> Content
    
    var body: some View {
        style
            .makeBody(
                configuration: PopUpStyleConfiguration(
                    label: PopUpStyleConfiguration.Label(content: content())
                )
            )
    }
}

// MARK: - Style Configuration
public struct PopUpStyleConfiguration {
    /// A type-erased content of a `PopUpStyle`.
    struct Label: View {
        let body: AnyView
        
        init<Content: View>(content: Content) {
            body = AnyView(content)
        }
    }
    
    let label: PopUpStyleConfiguration.Label
}

// MARK: - Base view styles
/// A popup with custom style.
public struct CustomStyle: PopUpStyleProtocol {
    public let textColor: Color
    public let itemBackgroundColor: Color
    public let itemCornerRadius: CGFloat
    public let itemPadding: CGFloat
    public let backgroundColor: Color
    public let borderColor: Color?
    public let cornerRadius: CGFloat
    public let arrowSize: CGSize
    public let opacity: Double
    public let shadowColor: Color?
    public let shadowOpacity: Double
    public let shadowRadius: CGFloat
    public let shadowOffset: CGPoint
    public let blurRadius: CGFloat
    
    /// - Parameters:
    ///   - textColor: Menu item text color.
    ///   - itemBackgroundColor: Menu item background color.
    ///   - itemCornerRadius: Menu item corner radius.
    ///   - itemPadding: Menu item padding.
    ///   - backgroundColor: Popup background color.
    ///   - borderColor: Popup border color.
    ///   - cornerRadius: Popup corner radius.
    ///   - arrowSize: Popup arrow size.
    ///   - opacity: Popup opacity.
    ///   - shadowColor: Popup shadow color.
    ///   - shadowOpacity: Popup shadow opacity.
    ///   - shadowRadius: Popup shadow radius.
    ///   - shadowOffset: Popup shadow offset.
    ///   - blurRadius: Popup blur radius.
    public init(
        textColor: Color,
        itemBackgroundColor: Color,
        itemCornerRadius: CGFloat = 4,
        itemPadding: CGFloat = 8,
        backgroundColor: Color,
        borderColor: Color? = nil,
        cornerRadius: CGFloat = 8,
        arrowSize: CGSize = CGSize(width: 8, height: 8),
        opacity: Double = 0.8,
        shadowColor: Color? = .black,
        shadowOpacity: Double = 0.4,
        shadowRadius: CGFloat = 10,
        shadowOffset: CGPoint = CGPoint(x: 2, y: 4),
        blurRadius: CGFloat = .zero
    ) {
        self.textColor = textColor
        self.itemBackgroundColor = itemBackgroundColor
        self.itemCornerRadius = itemCornerRadius
        self.itemPadding = itemPadding
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        self.arrowSize = arrowSize
        self.opacity = opacity
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.blurRadius = blurRadius
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(backgroundColor)
    }
}

/// A popup with dark style.
public struct DarkStyle: PopUpStyleProtocol {
    public let textColor: Color
    public let itemBackgroundColor: Color
    public let itemCornerRadius: CGFloat
    public let itemPadding: CGFloat
    public let backgroundColor: Color
    public let borderColor: Color?
    public let cornerRadius: CGFloat
    public let arrowSize: CGSize
    public let opacity: Double
    public let shadowColor: Color?
    public let shadowOpacity: Double
    public let shadowRadius: CGFloat
    public let shadowOffset: CGPoint
    public let blurRadius: CGFloat
    
    public init() {
        textColor = .white
        itemBackgroundColor = .black
        itemCornerRadius = 4
        itemPadding = 8
        backgroundColor = .black.opacity(0.4)
        borderColor = nil
        cornerRadius = 8
        arrowSize = CGSize(width: 8, height: 8)
        opacity = 0.8
        shadowColor = .black
        shadowOpacity = 0.4
        shadowRadius = 10
        shadowOffset = CGPoint(x: 2, y: 4)
        blurRadius = .zero
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(backgroundColor)
    }
}

// MARK: - Default view style
/// A popup with light style.
private struct LightStyle: PopUpStyleProtocol {
    let textColor: Color
    let itemBackgroundColor: Color
    let itemCornerRadius: CGFloat
    let itemPadding: CGFloat
    let backgroundColor: Color
    let borderColor: Color?
    let cornerRadius: CGFloat
    let arrowSize: CGSize
    let opacity: Double
    let shadowColor: Color?
    let shadowOpacity: Double
    let shadowRadius: CGFloat
    let shadowOffset: CGPoint
    let blurRadius: CGFloat
    
    init() {
        textColor = .black
        itemBackgroundColor = .white
        itemCornerRadius = 4
        itemPadding = 8
        backgroundColor = .white.opacity(0.6)
        borderColor = nil
        cornerRadius = 8
        arrowSize = CGSize(width: 8, height: 8)
        opacity = 0.8
        shadowColor = .black
        shadowOpacity = 0.4
        shadowRadius = 10
        shadowOffset = CGPoint(x: 2, y: 4)
        blurRadius = .zero
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(backgroundColor)
    }
}

// MARK: - Setup style
struct AnyPopUpStyle: PopUpStyleProtocol {
    let textColor: Color
    let itemBackgroundColor: Color
    let itemCornerRadius: CGFloat
    let itemPadding: CGFloat
    let backgroundColor: Color
    let borderColor: Color?
    let cornerRadius: CGFloat
    let arrowSize: CGSize
    let opacity: Double
    let shadowColor: Color?
    let shadowOpacity: Double
    let shadowRadius: CGFloat
    let shadowOffset: CGPoint
    let blurRadius: CGFloat
    
    private let _makeBody: (Configuration) -> AnyView
    
    init<S: PopUpStyleProtocol>(style: S) {
        textColor = style.textColor
        itemBackgroundColor = style.itemBackgroundColor
        itemCornerRadius = style.itemCornerRadius
        itemPadding = style.itemPadding
        backgroundColor = style.backgroundColor
        borderColor = style.borderColor
        cornerRadius = style.cornerRadius
        arrowSize = style.arrowSize
        opacity = style.opacity
        shadowColor = style.shadowColor
        shadowOpacity = style.shadowOpacity
        shadowRadius = style.shadowRadius
        shadowOffset = style.shadowOffset
        blurRadius = style.blurRadius
        
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - Create an environment key
private struct PopUpStyleKey: EnvironmentKey {
    static let defaultValue = AnyPopUpStyle(style: LightStyle())
}

// MARK: - Ext. New value to environment values
extension EnvironmentValues {
    var popUpStyle: AnyPopUpStyle {
        get { self[PopUpStyleKey.self] }
        set { self[PopUpStyleKey.self] = newValue }
    }
}

// MARK: - Ext. Dedicated convenience view modifier
extension View {
    /// Sets the style of this view.
    ///
    /// Set to `.darkStyle`
    /// or `.customStyle(textColor:itemBackgroundColor:backgroundColor:)`
    /// or any other style to apply the style.
    ///
    ///     let menuView = Text("Example")
    ///         .foregroundColor(.white)
    ///         .font(.custom("Seravek", size: 18))
    ///         .padding(8)
    ///         .background(.pink)
    ///         .cornerRadius(8)
    ///
    ///     let menuItems = [
    ///         "First item",
    ///         "Second item",
    ///         "Third item",
    ///         "Fourth item"
    ///     ]
    ///
    ///     PopUpMenuView(anyView: menuView, menuItems: menuItems) { index in
    ///         print("Dropdown index: \(index)")
    ///     }
    ///     .popUpMenuStyle(.darkStyle)
    ///
    /// - Parameter style: The popup style.
    ///
    /// - Returns: A view that sets the style of this view.
    public func popUpMenuStyle<S: PopUpStyleProtocol>(_ style: S) -> some View {
        environment(\.popUpStyle, AnyPopUpStyle(style: style))
    }
}
