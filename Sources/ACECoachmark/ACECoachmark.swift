//
//  ACECoachmark.swift
//  ACECoachmark
//
//  Created by Chris Ferdian on Nov 2024.
//
//  This file provides SwiftUI view modifiers for adding coachmark overlays.
//  Coachmarks are guided tooltips that highlight UI elements to improve user onboarding and experience.
//
//  The coachmark system utilizes SwiftUI’s `PreferenceKey` mechanism (`ACEPreference` and `ACEChildPreference`)
//  to store and manage highlighted views dynamically.
//
//  ## Features:
//  - Highlight UI elements using `.addCoachmark` and `.addChildCoachmark`
/// - Overlay coachmarks using `.applyCoachmarkLayer`, `.applyCoachmarkLayers`, and `.applyDefaultCoachmarkLayer`
/// - Fully customizable navigation and styling options
//
//  ## Usage Example:
//
//  ```swift
//  struct ContentView: View {
//      @State private var currentSpot: Int? = 1
//
//      var body: some View {
//          VStack {
//              Button("Tap Me") {}
//                  .addCoachmark(1, model: AceCoachmarkBaseModel(
//                      title: "Welcome",
//                      message: "Tap here to start"
//                  ))
//
//              Button("Next Step") {}
//                  .addCoachmark(2, model: AceCoachmarkBaseModel(
//                      title: "Next Action",
//                      message: "Continue to the next step"
//                  ))
//          }
//          .applyDefaultCoachmarkLayer(currentSpot: $currentSpot)
//      }
//  }
//  ```
//
//  ## Components:
//  - `ACEPreference`: Stores coachmark positions for parent views
//  - `ACEChildPreference`: Stores coachmark positions for child views
//  - `ACECoachmarkView`: Displays the highlighted tooltip overlay
//  - `ACECoachmarkContentView`: Default coachmark content with title, message, and navigation
//
//  This system ensures seamless integration of coachmarks in SwiftUI-based applications.

import SwiftUI

@available(iOS 14.0, *)
public extension View {
    
    /// Adds a coachmark to a view using an anchor preference.
    ///
    /// This function attaches a coachmark to the view by storing its anchor in a preference key (`ACEPreference`).
    /// Coachmarks provide guidance by highlighting UI elements and displaying helpful text.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the coachmark.
    ///   - model: The model containing text and other details for the coachmark.
    ///   - cornerRadius: The corner radius for the highlighted view. Defaults to `0`.
    ///
    /// - Returns: A modified view with an anchor preference set for coachmark rendering.
    ///
    /// - Example:
    /// ```swift
    /// Text("Tap here")
    ///     .addCoachmark(1, model: AceCoachmarkBaseModel(text: "This is a button"))
    /// ```
    @ViewBuilder
    func addCoachmark(_ id: Int, model: AceCoachmarkBaseModel, cornerRadius: CGFloat = 0) -> some View {
        self
            .anchorPreference(key: ACEPreference.self, value: .bounds) {
                [ACEViewProperty(id: id, anchor: $0, text: model, corderRadius: cornerRadius)]
            }
    }

    /// Adds a child coachmark to a view using an anchor preference.
    ///
    /// This function attaches a child coachmark to the view by storing its anchor in a preference key (`ACEChildPreference`).
    /// Child coachmarks can be used for multi-step guidance, highlighting nested UI elements.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the child coachmark.
    ///   - model: The model containing text and other details for the child coachmark.
    ///   - cornerRadius: The corner radius for the highlighted view. Defaults to `0`.
    ///
    /// - Returns: A modified view with an anchor preference set for child coachmark rendering.
    ///
    /// - Example:
    /// ```swift
    /// Text("Sub-option")
    ///     .addChildCoachmark(2, model: AceCoachmarkBaseModel(text: "This is a sub-option"))
    /// ```
    @ViewBuilder
    func addChildCoachmark(_ id: Int, model: AceCoachmarkBaseModel, cornerRadius: CGFloat = 0) -> some View {
        self
            .anchorPreference(key: ACEChildPreference.self, value: .bounds) {
                [ACEViewProperty(id: id, anchor: $0, text: model, corderRadius: cornerRadius)]
            }
    }

    /// Applies coachmark layers to a view, supporting both parent and child coachmarks.
    ///
    /// This function overlays coachmarks onto a view by merging preferences from both parent (`ACEPreference`)
    /// and child (`ACEChildPreference`) coachmarks. It highlights UI elements step by step, guiding users through the interface.
    ///
    /// - Parameters:
    ///   - currentSpot: A binding that tracks the currently active coachmark.
    ///   - showCloseButton: A Boolean flag to determine whether a close button is displayed. Defaults to `true`.
    ///   - imageArrowLeft: The image used for the left navigation arrow. Defaults to a system chevron left icon.
    ///   - imageArrowRight: The image used for the right navigation arrow. Defaults to a system chevron right icon.
    ///   - arrowSize: The size of the navigation arrows. Defaults to `32`.
    ///   - isTapToDissmissEnable: A Boolean flag that allows dismissing the coachmark with a tap. Defaults to `true`.
    ///   - onDismiss: A closure executed when the coachmark is dismissed. Defaults to `nil`.
    ///   - content: A `ViewBuilder` closure that provides the content for the coachmark view.
    ///
    /// - Returns: A modified view with an overlay that displays coachmarks for guiding users.
    ///
    /// - Example:
    /// ```swift
    /// VStack {
    ///     Button("Tap Me") {}
    ///         .addCoachmark(1, model: AceCoachmarkBaseModel(text: "This is a button"))
    ///
    ///     Text("Sub-option")
    ///         .addChildCoachmark(2, model: AceCoachmarkBaseModel(text: "This is a sub-option"))
    /// }
    /// .applyCoachmarkLayers(currentSpot: $currentCoachmark)
    /// ```
    func applyCoachmarkLayers<Content: View>(
        currentSpot: Binding<Int?>,
        showCloseButton: Bool = true,
        imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill"),
        imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill"),
        arrowSize: CGFloat = 32,
        isTapToDissmissEnable: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (AceCoachmarkBaseModel, Bool, Binding<Int?>, Int, (() -> Void)?) -> Content
    ) -> some View {
        Group {
            if currentSpot.wrappedValue == nil {
                self // Return the original view without modification
            } else {
                self.overlayPreferenceValue(ACEPreference.self) { parentValues in
                    self.overlayPreferenceValue(ACEChildPreference.self) { childValues in
                        let allValues = parentValues + childValues  // Merge both preferences

                        ZStack {
                            if let preference = allValues.first(where: { $0.id == currentSpot.wrappedValue }) {
                                GeometryReader { proxy in
                                    let anchor = proxy[preference.anchor]
                                    ACECoachmarkView(
                                        model: preference.text,
                                        showCloseButton: showCloseButton,
                                        highlightFrame: anchor,
                                        totalSpotsCount: allValues.count,
                                        currentSpot: currentSpot,
                                        imageLeft: imageArrowLeft,
                                        imageRight: imageArrowRight,
                                        arrowSize: arrowSize,
                                        onDismiss: onDismiss,
                                        targetViewCornerRadius: preference.corderRadius ?? 0,
                                        content: content
                                    )
                                }
                                .ignoresSafeArea()
                            }
                        }
                        .animation(.smooth, value: currentSpot.wrappedValue)
                    }
                }
            }
        }
    }


    /// Applies a single coachmark layer to highlight elements in the UI.
    ///
    /// This function overlays a coachmark on a view based on a stored preference (`ACEPreference`).
    /// It helps guide users step by step by highlighting UI elements dynamically.
    ///
    /// - Parameters:
    ///   - currentSpot: A binding that tracks the currently active coachmark ID.
    ///   - showCloseButton: A Boolean flag that determines whether a close button is shown. Defaults to `true`.
    ///   - imageArrowLeft: The image used for the left navigation arrow. Defaults to a system chevron left icon.
    ///   - imageArrowRight: The image used for the right navigation arrow. Defaults to a system chevron right icon.
    ///   - arrowSize: The size of the navigation arrows. Defaults to `32`.
    ///   - isTapToDissmissEnable: A Boolean flag that allows dismissing the coachmark with a tap. Defaults to `true`.
    ///   - onDismiss: A closure executed when the coachmark is dismissed. Defaults to `nil`.
    ///   - content: A `ViewBuilder` closure that provides custom content inside the coachmark.
    ///
    /// - Returns: A modified view with an overlay displaying a coachmark.
    ///
    /// - Example:
    /// ```swift
    /// VStack {
    ///     Button("Tap Me") {}
    ///         .addCoachmark(1, model: AceCoachmarkBaseModel(text: "This is a button"))
    /// }
    /// .applyCoachmarkLayer(currentSpot: $currentCoachmark)
    /// ```
    func applyCoachmarkLayer<Content: View>(
        currentSpot: Binding<Int?>,
        showCloseButton: Bool = true,
        imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill"),
        imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill"),
        arrowSize: CGFloat = 32,
        isTapToDissmissEnable: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (AceCoachmarkBaseModel, Bool, Binding<Int?>, Int, (() -> Void)?) -> Content
    ) -> some View {
        self.overlayPreferenceValue(ACEPreference.self) { values in
            GeometryReader { proxy in
                if let preference = values.first(where: { item in
                    item.id == currentSpot.wrappedValue
                }) {
                    let anchor = proxy[preference.anchor]
                    ACECoachmarkView(
                        model: preference.text,
                        showCloseButton: showCloseButton,
                        highlightFrame: anchor,
                        totalSpotsCount: values.count,
                        currentSpot: currentSpot,
                        imageLeft: imageArrowLeft,
                        imageRight: imageArrowRight,
                        arrowSize: arrowSize,
                        onDismiss: onDismiss,
                        targetViewCornerRadius: preference.corderRadius ?? 0,
                        content: content
                    )
                }
            }
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .animation(.smooth, value: currentSpot.wrappedValue)
        }
    }

    /// Applies a default coachmark layer to highlight UI elements with guided tooltips.
    ///
    /// This function overlays a coachmark on a view based on stored preferences (`ACEPreference`).
    /// It automatically provides a default content view (`ACECoachmarkContentView`) to display coachmark details.
    ///
    /// - Parameters:
    ///   - currentSpot: A binding that tracks the currently active coachmark ID.
    ///   - showCloseButton: A Boolean flag that determines whether a close button is shown. Defaults to `true`.
    ///   - imageArrowLeft: The image used for the left navigation arrow. Defaults to a system chevron left icon.
    ///   - imageArrowRight: The image used for the right navigation arrow. Defaults to a system chevron right icon.
    ///   - arrowSize: The size of the navigation arrows. Defaults to `32`.
    ///   - isTapToDissmissEnable: A Boolean flag that allows dismissing the coachmark with a tap. Defaults to `true`.
    ///   - onDismiss: A closure executed when the coachmark is dismissed. Defaults to `nil`.
    ///
    /// - Returns: A modified view with an overlay displaying a coachmark.
    ///
    /// - Example:
    /// ```swift
    /// VStack {
    ///     Button("Tap Me") {}
    ///         .addCoachmark(1, model: AceCoachmarkBaseModel(title: "Button", message: "Tap here to continue"))
    /// }
    /// .applyDefaultCoachmarkLayer(currentSpot: $currentCoachmark)
    /// ```
    func applyDefaultCoachmarkLayer(
        currentSpot: Binding<Int?>,
        showCloseButton: Bool = true,
        imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill"),
        imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill"),
        arrowSize: CGFloat = 32,
        isTapToDissmissEnable: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.overlayPreferenceValue(ACEPreference.self) { values in
            GeometryReader { proxy in
                if let preference = values.first(where: { item in
                    item.id == currentSpot.wrappedValue
                }) {
                    let anchor = proxy[preference.anchor]
                    ACECoachmarkView(
                        model: preference.text,
                        showCloseButton: showCloseButton,
                        highlightFrame: anchor,
                        totalSpotsCount: values.count,
                        currentSpot: currentSpot,
                        imageLeft: imageArrowLeft,
                        imageRight: imageArrowRight,
                        arrowSize: arrowSize,
                        onDismiss: onDismiss,
                        targetViewCornerRadius: preference.corderRadius ?? 0
                    ) { model, showClose, current, totalSpot, onDismiss in
                        ACECoachmarkContentView(
                            title: model.title,
                            message: model.message,
                            showCloseButton: showClose,
                            onDismiss: onDismiss,
                            currentSpot: current,
                            totalSpotsCount: totalSpot
                        )
                    }
                }
            }
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .animation(.smooth, value: currentSpot.wrappedValue)
        }
    }

}
