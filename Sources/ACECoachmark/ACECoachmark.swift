// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@available(iOS 15.0, *)
public extension View {
    
    @ViewBuilder
    func addCoachmark(_ id: Int, text: String) -> some View {
        self
            .anchorPreference(key: ACEPreference.self, value: .bounds) {
                [id: ACEViewProperty(anchor: $0, text: text)]
            }
    }
    
    func applyCoachmarkLayer(currentSpot: Binding<Int?>) -> some View {
        self.overlayPreferenceValue(ACEPreference.self) { values in
            GeometryReader { proxy in
                if let preference = values.first(where: { item in
                    item.key == currentSpot.wrappedValue
                }) {
                    let anchor = proxy[preference.value.anchor]
                    
                    ACECoachmarkView(
                        messages: preference.value.text,
                        highlightFrame: anchor,
                        totalSpotsCount: values.count,
                        currentSpot: currentSpot
                    ) {
                        
                    }
                }
            }
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .animation(.easeInOut, value: currentSpot.wrappedValue)
        }
    }
}
