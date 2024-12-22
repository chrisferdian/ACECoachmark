//
//  ACeCoachmarkView.swift
//  ACECoachmark
//
//  Created by Indo Teknologi Utama on 15/11/24.
//

import SwiftUI

struct ACECoachmarkView: View {
    private let TAG: String = "ACECoachmarkView"
    
    var imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill")
    var imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill")
    var arrowSize: CGFloat = 32
    var model: AceCoachmarkBaseModel
    var showCloseButton: Bool
    var highlightFrame: CGRect
    var totalSpotsCount: Int
    var onDismiss: (() -> Void)?
    
    @Binding var currentSpot: Int?
    @State private var currentIndex: Int = 0
    @State private var horizontalPosition: HorizontalPosition = .none
    @State private var verticalPosition: VerticalPosition = .none
    @State private var yPosition: CGFloat = 0
    
    init(
        model: AceCoachmarkBaseModel,
        showCloseButton: Bool,
        highlightFrame: CGRect,
        totalSpotsCount: Int,
        currentSpot: Binding<Int?>,
        onDismiss: (() -> Void)?,
        vPosition: VerticalPosition
    ) {
        self.model = model
        self.showCloseButton = showCloseButton
        self.highlightFrame = highlightFrame
        self._currentSpot = currentSpot
        self.totalSpotsCount = totalSpotsCount
        self.onDismiss = onDismiss
        self.verticalPosition = vPosition
    }
    
    init(
        model: AceCoachmarkBaseModel,
        showCloseButton: Bool,
        highlightFrame: CGRect,
        totalSpotsCount: Int,
        currentSpot: Binding<Int?>,
        imageLeft: Image,
        imageRight: Image,
        arrowSize: CGFloat,
        onDismiss: (() -> Void)?,
        vPosition: VerticalPosition
    ) {
        self.model = model
        self.showCloseButton = showCloseButton
        self.highlightFrame = highlightFrame
        self._currentSpot = currentSpot
        self.totalSpotsCount = totalSpotsCount
        self.imageArrowLeft = imageLeft
        self.imageArrowRight = imageRight
        self.arrowSize = arrowSize
        self.onDismiss = onDismiss
        self.verticalPosition = vPosition
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Dimmed background
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .mask(
                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .frame(width: highlightFrame.width, height: highlightFrame.height)
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
            VStack {
                if highlightFrame.maxY > UIScreen.main.bounds.height * 0.7 {
                    // Anchor near the bottom, content goes above
                    if horizontalPosition == .center {
                        Spacer()
                            .frame(maxHeight: highlightFrame.minY - 144 - 16 - 12)
                        HStack {
                            ACECoachmarkContentView(
                                title: model.title,
                                message: model.message,
                                showCloseButton: showCloseButton,
                                onDismiss: onDismiss,
                                currentSpot: $currentSpot,
                                totalSpotsCount: totalSpotsCount
                            )
                            .padding(.horizontal, 16)
                        }
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.white)
                            .offset(x: arrowOffset, y: -2)
                    } else if horizontalPosition == .right {
                        Spacer()
                            .frame(maxHeight: highlightFrame.minY - 144 - 16 - 12)
                        HStack {
                            Spacer()
                            ACECoachmarkContentView(
                                title: model.title,
                                message: model.message,
                                showCloseButton: showCloseButton,
                                onDismiss: onDismiss,
                                currentSpot: $currentSpot,
                                totalSpotsCount: totalSpotsCount
                            )
                            .padding(.horizontal, 16)
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.white)
                                .offset(x: -32, y: -2)
                        }
                    } else if horizontalPosition == .left {
                        Spacer()
                            .frame(maxHeight: highlightFrame.minY - 144 - 16 - 12)
                        HStack {
                            ACECoachmarkContentView(
                                title: model.title,
                                message: model.message,
                                showCloseButton: showCloseButton,
                                onDismiss: onDismiss,
                                currentSpot: $currentSpot,
                                totalSpotsCount: totalSpotsCount
                            )
                            .padding(.horizontal, 16)
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.white)
                                .offset(x: 32, y: -2)
                            Spacer()
                        }
                    }
                } else {
                    // Anchor near the top, content goes below
                    Spacer().frame(height: highlightFrame.maxY + 16 + 12)
                    if horizontalPosition == .center {
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(.white)
                            .offset(x: arrowOffset, y: 3)
                        HStack {
                            Spacer()
                            ACECoachmarkContentView(
                                title: model.title,
                                message: model.message,
                                showCloseButton: showCloseButton,
                                onDismiss: onDismiss,
                                currentSpot: $currentSpot,
                                totalSpotsCount: totalSpotsCount
                            )
                            .padding(.horizontal, 16)
                            Spacer()
                        }
                    } else if horizontalPosition == .left {
                        HStack {
                            Image(systemName: "arrowtriangle.up.fill")
                                .foregroundColor(.white)
                                .offset(x: 32, y: 4)
                            Spacer()
                        }
                        HStack {
                            ACECoachmarkContentView(
                                title: model.title,
                                message: model.message,
                                showCloseButton: showCloseButton,
                                onDismiss: onDismiss,
                                currentSpot: $currentSpot,
                                totalSpotsCount: totalSpotsCount
                            )
                            .padding(.horizontal, 16)
                            Spacer()
                        }
                    } else if horizontalPosition == .right {
                        HStack {
                            Spacer()
                            Image(systemName: "arrowtriangle.up.fill")
                                .foregroundColor(.white)
                                .offset(x: -32, y: 4)
                        }
                        HStack {
                            Spacer()
                            ACECoachmarkContentView(
                                title: model.title,
                                message: model.message,
                                showCloseButton: showCloseButton,
                                onDismiss: onDismiss,
                                currentSpot: $currentSpot,
                                totalSpotsCount: totalSpotsCount
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .onAppear { updatePosition(for: highlightFrame) }
            .onChange(of: highlightFrame, perform: updatePosition)
        }
    }
    
    // Dynamic Y position based on highlight frame and vertical position
    func updateYPosition() {
        let padding: CGFloat = 8
        let additionalOffset: CGFloat = 16
        
        switch verticalPosition {
        case .top:
            yPosition = highlightFrame.minY + padding
        case .center:
            yPosition = highlightFrame.midY + (highlightFrame.height / 2) + padding
        case .bottom:
            yPosition = highlightFrame.minY //- highlightFrame.height - additionalOffset
        case .none:
            yPosition = .zero
        }
        print(highlightFrame.maxY)
        print(yPosition)
    }
    
    // Dynamic X position based on highlight frame and horizontal position
    var xPositionArrow: CGFloat {
        let padding: CGFloat = 8
        let additionalOffset: CGFloat = 16
        
        switch horizontalPosition {
        case .left:
            return highlightFrame.minX + highlightFrame.width + additionalOffset
        case .center:
            return highlightFrame.midX
        case .right:
            return highlightFrame.minX - highlightFrame.width
        case .none: return 0
        }
    }
    private func updatePosition(for rect: CGRect) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Calculate the center of the rect
        let midX = rect.midX
        let midY = rect.midY
        
        // Determine horizontal position
        horizontalPosition = midX <= screenWidth / 3 ? .left : (midX >= 2 * screenWidth / 3 ? .right : .center)
        
        // Determine vertical position
        verticalPosition = midY <= screenHeight / 3 ? .top : (midY >= 2 * screenHeight / 3 ? .bottom : .center)
        updateYPosition()
        logDebugInfo()
        
    }
    
    // Determine alignment based on position
    var arrowPosition: HorizontalAlignment {
        switch horizontalPosition {
        case .left: return .leading
        case .center, .none: return .center
        case .right: return .trailing
        }
    }
    
    // Arrow offset based on position
    var arrowOffset: CGFloat {
        switch horizontalPosition {
        case .left: return 16
        case .center, .none: return 0
        case .right: return -16
        }
    }
    
    private func logDebugInfo() {
        print("[\(TAG)] Target size width : \(highlightFrame.width)")
        print("[\(TAG)] Target size height : \(highlightFrame.height)")
        print("[\(TAG)] Horizontal: \(horizontalPosition.rawValue)")
        print("[\(TAG)] Vertical: \(verticalPosition.rawValue)")
    }
}
