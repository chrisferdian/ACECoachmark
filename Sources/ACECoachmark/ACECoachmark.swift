// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 14.0, *)
public extension View {
    
    @ViewBuilder
    func addCoachmark(_ id: Int, model: AceCoachmarkBaseModel) -> some View {
        self
            .anchorPreference(key: ACEPreference.self, value: .bounds, transform: { [id: ACEViewProperty(anchor: $0, text: model)] })
    }
    
    func applyCoachmarkLayer(
        currentSpot: Binding<Int?>,
        showCloseButton: Bool = true,
        imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill"),
        imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill"),
        arrowSize: CGFloat = 32,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.overlayPreferenceValue(ACEPreference.self) { values in
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
                        vPosition: getVerticalPosition(for: anchor)
                    )
                    
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
