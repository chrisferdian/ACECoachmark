//
//  ACeCoachmarkView.swift
//  ACECoachmark
//
//  Created by Indo Teknologi Utama on 15/11/24.
//

import SwiftUI

struct ACECoachmarkView: View {
    var messages: String
    var highlightFrame: CGRect
    @Binding var currentSpot: Int?
    var totalSpotsCount: Int
    
    @State
    private var currentIndex: Int = 0
    
    var onDismiss: () -> Void
    @State private var horizontalPosition: HorizontalPosition
    @State private var verticalPosition: VerticalPosition
    
    init(messages: String, highlightFrame: CGRect, totalSpotsCount: Int, currentSpot: Binding<Int?>, onDismiss: @escaping () -> Void) {
        self.messages = messages
        self.highlightFrame = highlightFrame
        self._currentSpot = currentSpot
        self.totalSpotsCount = totalSpotsCount
        self.onDismiss = onDismiss
        // Screen dimensions
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let maxX = highlightFrame.midX
        let maxY = highlightFrame.maxY
        
        // Determine horizontal position based on maxX and screen width
        if maxX <= screenWidth / 3 {
            horizontalPosition = .left
        } else if maxX >= 2 * screenWidth / 3 {
            horizontalPosition = .right
        } else {
            horizontalPosition = .center
        }
        
        // Determine vertical position based on maxY and screen height
        if maxY <= screenHeight / 3 {
            verticalPosition = .top
        } else if maxY >= 2 * screenHeight / 3 {
            verticalPosition = .bottom
        } else {
            verticalPosition = .center
        }
    }
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .mask({
                    Rectangle()
                        .overlay(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 0)
                                .frame(width: highlightFrame.width + 8,
                                       height: highlightFrame.height + 8)
                                .offset(x: highlightFrame.minX - 4,
                                        y: highlightFrame.minY - 4)
                                .blendMode(.destinationOut)
                        }
                })
                .onTapGesture {
                    currentSpot = totalSpotsCount
                }
            VStack(alignment: arrowPosition, spacing: 0) {
                if verticalPosition == .top {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(.white)
                        .offset(x: arrowOffset, y: 2)
                    content
                }
                if verticalPosition == .center {
                    Image(systemName: "arrowtriangle.up.fill")
                        .foregroundColor(.white)
                        .offset(x: arrowOffset, y: 2)
                    content
                }
                if verticalPosition == .bottom {
                    content
                    Image(systemName: "arrowtriangle.down.fill")
                        .foregroundColor(.white)
                        .offset(x: arrowOffset, y: -2)
                    
                }
            }
            .onChange(of: highlightFrame, perform: { newValue in
                withAnimation {
                    updatePosition(for: newValue)
                }
            })
            .frame(maxWidth: UIScreen.main.bounds.width / 2)
            .position(x: xPositionArrow, y: YPosition)
        }
        .frame(maxWidth: UIScreen.main.bounds.width)
    }
    var YPosition: CGFloat {
        switch verticalPosition {
        case .top:
            return highlightFrame.maxY + (highlightFrame.height * 2) + 8
        case .center:
            return highlightFrame.midY + (highlightFrame.height)
        case .bottom:
            switch horizontalPosition {
            case .left:
                return highlightFrame.minY - (highlightFrame.height * 2)
            case .center:
                return highlightFrame.minY - (highlightFrame.height / 2) - 16
            case .right:
                return highlightFrame.minY - (highlightFrame.height * 2)
            }
        }
    }
    var xPositionArrow: CGFloat {
        switch horizontalPosition {
        case .left:
            return highlightFrame.maxX + 16
        case .center:
            return highlightFrame.midX
        case .right:
            return highlightFrame.minX
        }
    }
    private func updatePosition(for rect: CGRect) {
        // Screen dimensions
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let maxX = rect.midX
        let maxY = rect.maxY
        
        // Determine horizontal position based on maxX and screen width
        if maxX <= screenWidth / 3 {
            horizontalPosition = .left
        } else if maxX >= 2 * screenWidth / 3 {
            horizontalPosition = .right
        } else {
            horizontalPosition = .center
        }
        
        // Determine vertical position based on maxY and screen height
        if maxY <= screenHeight / 3 {
            verticalPosition = .top
        } else if maxY >= 2 * screenHeight / 3 {
            verticalPosition = .bottom
        } else {
            verticalPosition = .center
        }
    }
    
    
    //content
    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text("Title")
                Spacer()
                Button(action: {
                    currentSpot = totalSpotsCount
                }) {
                    Image(systemName: "xmark")
                        .frame(width: 16, height: 16, alignment: .center)
                }
            }
            .padding(.top, 12)
            
            Text("\(highlightFrame.debugDescription)")
                .foregroundColor(.black)
                .background(Color.white)
                .font(.system(size: 12))
                .padding(.bottom, messages.count > 1 ? 0 : 12)
            
            Text(
"""
                Horizontal: \(horizontalPosition.rawValue)
                Vertical: \(verticalPosition.rawValue)
"""
            ).font(.system(size: 12))
            
            if totalSpotsCount > 1 {
                HStack(alignment: .center, spacing: 0, content: {
                    Text("\((currentSpot ?? 0) + 1)/\(totalSpotsCount)")
                        .font(.system(size: 12))
                    Spacer()
                    HStack(alignment: .center, spacing: 8, content: {
                        if (currentSpot ?? 0) > 0 {
                            Button {
                                guard let currentSpotIndex = self.currentSpot else { return }
                                currentSpot = currentSpotIndex - 1
                            } label: {
                                Image(systemName: "chevron.left.circle.fill")
                            }
                            .frame(width: 32, height: 32, alignment: .center)
                            .foregroundColor(.orange)
                            .disabled((currentSpot ?? 0) <= 0)
                            .font(.system(size: 32))
                        }
                        if (currentSpot ?? 0) < (totalSpotsCount - 1) {
                            Button {
                                guard let currentSpotIndex = self.currentSpot else { return }
                                currentSpot = currentSpotIndex + 1
                            } label: {
                                Image(systemName: "chevron.forward.circle.fill")
                            }
                            .frame(width: 32, height: 32, alignment: .center)
                            .foregroundColor(.orange)
                            .font(.system(size: 32))
                        }
                    })
                })
                .padding(.bottom, 12)
            }
        }
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(10)
    }
    var arrowPosition: HorizontalAlignment {
        switch horizontalPosition {
        case .left:
            return .leading
        case .center:
            return .center
        case .right:
            return .trailing
        }
    }
    var arrowOffset: CGFloat {
        switch horizontalPosition {
        case .left:
            return 8
        case .center:
            return 0
        case .right:
            return -16
        }
    }
}
