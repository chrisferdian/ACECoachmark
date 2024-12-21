//
//  ACeCoachmarkView.swift
//  ACECoachmark
//
//  Created by Indo Teknologi Utama on 15/11/24.
//

import SwiftUI

struct ACECoachmarkView: View {
    private let TAG: String = "ACECoachmarkView"
    
    var model: AceCoachmarkBaseModel
    var showCloseButton: Bool
    var highlightFrame: CGRect
    @Binding var currentSpot: Int?
    var totalSpotsCount: Int
    var onDismiss: (() -> Void)?

    @State private var currentIndex: Int = 0
    @State private var horizontalPosition: HorizontalPosition = .center
    @State private var verticalPosition: VerticalPosition = .center

    init(model: AceCoachmarkBaseModel, showCloseButton: Bool, highlightFrame: CGRect, totalSpotsCount: Int, currentSpot: Binding<Int?>, onDismiss: (() -> Void)?) {
        self.model = model
        self.showCloseButton = showCloseButton
        self.highlightFrame = highlightFrame
        self._currentSpot = currentSpot
        self.totalSpotsCount = totalSpotsCount
        self.onDismiss = onDismiss
    }

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .mask(
                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .frame(width: highlightFrame.width + 8, height: highlightFrame.height + 8)
                                    .position(
                                        x: highlightFrame.minX + highlightFrame.width / 2,
                                        y: highlightFrame.minY + highlightFrame.height / 2
                                    )
                                    .blendMode(.destinationOut)
                            )
                            .compositingGroup() // Required for blend mode
                    }
                )
                .onTapGesture {
                    onDismiss?()
                    currentSpot = totalSpotsCount
                }

            VStack(alignment: arrowPosition, spacing: 0) {
                if verticalPosition == .top {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(.white)
                        .offset(x: arrowOffset, y: 2)
                    content
                } else if verticalPosition == .center {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(.white)
                        .offset(x: arrowOffset, y: 2)
                    content
                } else if verticalPosition == .bottom {
                    content
                    Image(systemName: "arrowtriangle.down.fill")
                        .foregroundColor(.white)
                        .offset(x: arrowOffset, y: -2)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 2)
            .position(x: xPositionArrow, y: yPosition)
            .onAppear { updatePosition(for: highlightFrame) }
            .onChange(of: highlightFrame, perform: { newValue in
                updatePosition(for: newValue)
            })
        }
    }

    // Dynamic Y position based on highlight frame and vertical position
    var yPosition: CGFloat {
        switch verticalPosition {
        case .top:
            return highlightFrame.maxY + (highlightFrame.height * 2) + 8
        case .center:
            return highlightFrame.midY + (highlightFrame.height) + 8
        case .bottom:
            return highlightFrame.minY - (highlightFrame.height / 2) - 16
        }
    }

    // Dynamic X position based on highlight frame and horizontal position
    var xPositionArrow: CGFloat {
        switch horizontalPosition {
        case .left:
            return highlightFrame.maxX// + highlightFrame.width + 16
        case .center:
            return highlightFrame.midX
        case .right:
            return highlightFrame.minX// - highlightFrame.width
        }
    }

    // Update position based on current highlight frame dimensions
    private func updatePosition(for rect: CGRect) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let maxX = rect.midX
        let maxY = rect.maxY

        horizontalPosition = maxX <= screenWidth / 3 ? .left : (maxX >= 2 * screenWidth / 3 ? .right : .center)
        verticalPosition = maxY <= screenHeight / 3 ? .top : (maxY >= 2 * screenHeight / 3 ? .bottom : .center)
        logDebugInfo()
    }

    // Content view for the message and navigation
    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            if model.title != nil || showCloseButton {
                HStack(alignment: .center) {
                    if let _title = model.title {
                        Text(_title)
                            .font(.system(size: 12, weight: .medium))
                    }
                    Spacer()
                    if showCloseButton {
                        Button(action: {
                            onDismiss?()
                            currentSpot = totalSpotsCount
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 16, height: 16)
                        }
                        .font(.system(.title))
                    }
                }
                .padding(.top, 12)
            }
            if let _message = model.message {
                Text(_message)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .font(.system(.caption))
                    .padding(.bottom, totalSpotsCount > 1 ? 12 : 0)
            }

            if totalSpotsCount > 1 {
                HStack {
                    Text("\((currentSpot ?? 0) + 1)/\(totalSpotsCount)")
                        .font(.system(.caption))
                    Spacer()
                    HStack(spacing: 8) {
                        if (currentSpot ?? 0) > 0 {
                            Button {
                                guard let index = currentSpot else { return }
                                currentSpot = index - 1
                            } label: {
                                Image(systemName: "chevron.left.circle.fill")
                            }
                            .foregroundColor(.orange)
                            .font(.system(.title))
                        }
                        if (currentSpot ?? 0) < (totalSpotsCount - 1) {
                            Button {
                                guard let index = currentSpot else { return }
                                currentSpot = index + 1
                            } label: {
                                Image(systemName: "chevron.forward.circle.fill")
                            }
                            .foregroundColor(.orange)
                            .font(.system(.title))
                        }
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
    }

    // Determine alignment based on position
    var arrowPosition: HorizontalAlignment {
        switch horizontalPosition {
        case .left: return .leading
        case .center: return .center
        case .right: return .trailing
        }
    }

    // Arrow offset based on position
    var arrowOffset: CGFloat {
        switch horizontalPosition {
        case .left: return 16
        case .center: return 0
        case .right: return -16
        }
    }
    
    private func logDebugInfo() {
        print("[\(TAG)] Horizontal: \(horizontalPosition.rawValue)")
        print("[\(TAG)] Vertical: \(verticalPosition.rawValue)")
    }
}
