//
//  ACETooltipView.swift
//  ACECoachmark
import SwiftUI

public struct ACETooltipView<Content: View>: View {
    private let TAG: String = "ACECoachmarkView"
    
    var arrowSize: CGFloat = 32
    var text: String
    var highlightFrame: CGRect
    var isTapToDismiss: Bool
    var onDismiss: (() -> Void)?
    var position: ACETooltipPosition
    
    @Binding private var currentSpot: Int?
    @State private var tooltipSize: CGSize = .zero
    private let horizontalPadding: CGFloat = 32
    
    let content: (String, ACETooltipPosition) -> Content
    
    public init(
        text: String,
        highlightFrame: CGRect,
        tooltipPosition: ACETooltipPosition,
        currentSpot: Binding<Int?>,
        onDismiss: (() -> Void)?,
        tapToDismiss: Bool = true,
        @ViewBuilder content: @escaping (String, ACETooltipPosition) -> Content
    ) {
        self.text = text
        self.highlightFrame = highlightFrame
        self._currentSpot = currentSpot
        self.position = tooltipPosition
        self.onDismiss = onDismiss
        self.isTapToDismiss = true
        self.content = content
    }
    
    public var body: some View {
        switch position {
        case .top, .bottom:
            ZStack(alignment: .center, content: {
                if position == .top {
                    content(text, position)
                        .readContentSize(onChange: { newSize in
                            self.tooltipSize = newSize
                        })
                        .padding(.top, highlightFrame.minY - tooltipSize.height)
                }
            })
            .onTapGesture {
                if isTapToDismiss {
                    onDismiss?()
                    currentSpot = nil
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width)
            .background(Color.clear) // Ensure visibility
            .cornerRadius(8)
            .shadow(radius: 5)
        case .left, .right:
            ZStack(alignment: .center, content: {
                if position == .right {
                    content(text, position)
                        .readContentSize(onChange: { newSize in
                            self.tooltipSize = newSize
                        })
                        .padding(.leading, (highlightFrame.maxX))
                        .padding(.top, highlightFrame.midY - tooltipSize.height / 2)
                } else if position == .left {
                    content(text, position)
                        .readContentSize(onChange: { newSize in
                            self.tooltipSize = newSize
                        })
                        .padding(.trailing, (highlightFrame.minX + highlightFrame.width))
                        .padding(.top, highlightFrame.midY - tooltipSize.height / 2)
                }
            })
            .onTapGesture {
                if isTapToDismiss {
                    onDismiss?()
                    currentSpot = nil
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width)
            .background(Color.clear)
            .cornerRadius(8)
            .shadow(radius: 5)
        }
    }
    
    func makePosition() -> (x: CGFloat, y: CGFloat) {
        let padding: CGFloat = 8
        switch position {
        case .top:
            return (highlightFrame.midX, highlightFrame.midY)
        case .bottom:
            return (highlightFrame.midX, highlightFrame.maxY)
        case .left, .right:
            return (0, highlightFrame.midY)
        }
    }
}

private struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

private extension View {
    internal func readContentSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: ContentSizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(ContentSizePreferenceKey.self, perform: onChange)
    }
}
