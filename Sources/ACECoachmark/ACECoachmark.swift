// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 14.0, *)
public extension View {
    
    @ViewBuilder
    func addCoachmark(_ id: Int, model: AceCoachmarkBaseModel, cornerRadius: CGFloat = 0) -> some View {
        self
            .anchorPreference(key: ACEPreference.self, value: .bounds, transform: { [id: ACEViewProperty(anchor: $0, text: model, corderRadius: cornerRadius)] })
    }
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
            let _ = print(values.map({ $0.key }))
            GeometryReader { proxy in
                if let preference = values.first(where: { item in
                    item.key == currentSpot.wrappedValue
                }) {
                    let anchor = proxy[preference.value.anchor]
                    ACECoachmarkView(
                        model: preference.value.text,
                        showCloseButton: showCloseButton,
                        highlightFrame: anchor,
                        totalSpotsCount: values.count,
                        currentSpot: currentSpot,
                        imageLeft: imageArrowLeft,
                        imageRight: imageArrowRight,
                        arrowSize: arrowSize,
                        onDismiss: onDismiss,
                        vPosition: getVerticalPosition(for: anchor),
                        targetViewCornerRadius: preference.value.corderRadius ?? 0,
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
    func applyDefaultCoachmarkLayer<Content: View>(
        currentSpot: Binding<Int?>,
        showCloseButton: Bool = true,
        imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill"),
        imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill"),
        arrowSize: CGFloat = 32,
        isTapToDissmissEnable: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.overlayPreferenceValue(ACEPreference.self) { values in
            let _ = print(values.map({ $0.key }))
            GeometryReader { proxy in
                if let preference = values.first(where: { item in
                    item.key == currentSpot.wrappedValue
                }) {
                    let anchor = proxy[preference.value.anchor]
                    ACECoachmarkView(
                        model: preference.value.text,
                        showCloseButton: showCloseButton,
                        highlightFrame: anchor,
                        totalSpotsCount: values.count,
                        currentSpot: currentSpot,
                        imageLeft: imageArrowLeft,
                        imageRight: imageArrowRight,
                        arrowSize: arrowSize,
                        onDismiss: onDismiss,
                        vPosition: getVerticalPosition(for: anchor),
                        targetViewCornerRadius: preference.value.corderRadius ?? 0) { model, showClose, current, totalSpot, onDismiss in
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
    private func getVerticalPosition(for highlightFrame: CGRect) -> VerticalPosition {
        let screenHeight = UIScreen.main.bounds.height
        let maxY = highlightFrame.maxY

        if maxY <= screenHeight / 3 {
            return .top
        } else if maxY >= 2 * screenHeight / 3 {
            return .bottom
        } else {
            return .center
        }
    }
}
