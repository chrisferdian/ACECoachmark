//
//  ACETooltipView.swift
//  ACECoachmark
import SwiftUI

public struct ACETooltipView<Content: View>: View {
    private let TAG: String = "ACECoachmarkView"

    var arrowSize: CGFloat = 16
    var text: String
    var highlightFrame: CGRect
    var isTapToDismiss: Bool
    var onDismiss: (() -> Void)?
    var position: ACETooltipPosition

    @Binding private var currentSpot: Int?
    @State private var tooltipSize: CGSize = .zero

    private let horizontalPadding: CGFloat = 16
    private let verticalPadding: CGFloat = 16

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
        self.isTapToDismiss = tapToDismiss
        self.content = content
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // Arrow
                arrowView
                    .position(calculateArrowPosition())

                // Tooltip
                content(text, position)
                    .readContentSize(onChange: { newSize in
                        tooltipSize = newSize
                    })
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .frame(
                        maxWidth: getMaxWidth(for: position, in: geo.size),
                        maxHeight: getMaxHeight(for: position, in: geo.size)
                    )
                    .padding(.vertical, geo.safeAreaInsets.top)
                    .position(calculatePosition(screenWidth: geo.size.width, screenHeight: geo.size.height))
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(Color.clear)
            .onTapGesture {
                if isTapToDismiss {
                    onDismiss?()
                    currentSpot = nil
                }
            }
        }
    }

    private func getMaxWidth(for position: ACETooltipPosition, in containerSize: CGSize) -> CGFloat {
        switch position {
        case .left:
            return max(0, highlightFrame.minX - 8)
        case .right:
            return max(0, containerSize.width - highlightFrame.maxX - 8)
        case .top, .bottom:
            return containerSize.width - 2 * horizontalPadding
        }
    }

    private func getMaxHeight(for position: ACETooltipPosition, in containerSize: CGSize) -> CGFloat {
        switch position {
        case .top:
            return max(0, highlightFrame.minY - 8)
        case .bottom:
            return max(0, containerSize.height - highlightFrame.maxY - 8)
        case .left, .right:
            return containerSize.height - 2 * verticalPadding
        }
    }

    private func calculatePosition(screenWidth: CGFloat, screenHeight: CGFloat) -> CGPoint {
        let tooltipWidth = tooltipSize.width
        let tooltipHeight = tooltipSize.height

        var x: CGFloat = 0
        var y: CGFloat = 0

        switch position {
        case .top:
            x = clamp(
                highlightFrame.midX - tooltipWidth / 2,
                min: horizontalPadding,
                max: screenWidth - tooltipWidth - horizontalPadding
            ) + tooltipWidth / 2

            y = highlightFrame.minY - tooltipHeight / 2 - arrowSize
            y = max(y, tooltipHeight / 2 + verticalPadding)

        case .bottom:
            x = clamp(
                highlightFrame.midX - tooltipWidth / 2,
                min: horizontalPadding,
                max: screenWidth - tooltipWidth - horizontalPadding
            ) + tooltipWidth / 2

            y = highlightFrame.maxY + tooltipHeight / 2 + arrowSize
            y = min(y, screenHeight - tooltipHeight / 2 - verticalPadding)

        case .left:
            x = highlightFrame.minX - tooltipWidth / 2 - arrowSize
            y = clamp(
                highlightFrame.midY - tooltipHeight / 2,
                min: verticalPadding,
                max: screenHeight - tooltipHeight - verticalPadding
            ) + tooltipHeight / 2

        case .right:
            x = highlightFrame.maxX + tooltipWidth / 2 + arrowSize
            y = clamp(
                highlightFrame.midY - tooltipHeight / 2,
                min: verticalPadding,
                max: screenHeight - tooltipHeight - verticalPadding
            ) + tooltipHeight / 2
        }

        return CGPoint(x: x, y: y)
    }

    private func calculateArrowPosition() -> CGPoint {
        switch position {
        case .top:
            return CGPoint(
                x: highlightFrame.midX,
                y: highlightFrame.minY - arrowSize / 2
            )
        case .bottom:
            return CGPoint(
                x: highlightFrame.midX,
                y: highlightFrame.maxY + arrowSize / 2
            )
        case .left:
            return CGPoint(
                x: highlightFrame.minX - arrowSize / 2,
                y: highlightFrame.midY
            )
        case .right:
            return CGPoint(
                x: highlightFrame.maxX + arrowSize / 2,
                y: highlightFrame.midY
            )
        }
    }

    private var arrowView: some View {
        Triangle()
            .fill(Color.white)
            .frame(width: arrowSize, height: arrowSize)
            .rotationEffect(arrowRotation)
            .shadow(radius: 4)
    }

    private var arrowRotation: Angle {
        switch position {
        case .top:
            return .degrees(180)
        case .bottom:
            return .degrees(0)
        case .left:
            return .degrees(90)
        case .right:
            return .degrees(-90)
        }
    }

    private func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        return Swift.max(min, Swift.min(max, value))
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


#Preview {
    CoachmarkExampleView()
}
