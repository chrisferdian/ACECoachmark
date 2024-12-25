
//
//  ACECoachmarkContentView.swift
//  ACECoachmark
//
//  Created by Indo Teknologi Utama on 22/12/24.
//

import SwiftUI

public struct ACECoachmarkContentView: View {
    
    var title: String?
    var message: String?
    let showCloseButton: Bool
    let onDismiss: (() -> Void)?
    @Binding var currentSpot: Int?
    let totalSpotsCount: Int
    var imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill")
    var imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill")
    var imageClose: Image = Image(systemName: "xmark")

    private let arrowSize: CGFloat = 16

    public init(title: String? = nil, message: String? = nil, showCloseButton: Bool, onDismiss: ( () -> Void)?, currentSpot: Binding<Int?> = .constant(nil), totalSpotsCount: Int, imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill"), imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill"), imageClose: Image = Image(systemName: "xmark")) {
        self.title = title
        self.message = message
        self.showCloseButton = showCloseButton
        self.onDismiss = onDismiss
        self._currentSpot = currentSpot
        self.totalSpotsCount = totalSpotsCount
        self.imageArrowLeft = imageArrowLeft
        self.imageArrowRight = imageArrowRight
        self.imageClose = imageClose
    }
    public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HeaderView()
                MessageView()
                PaginationView()
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(10)
            .frame(maxWidth: UIScreen.main.bounds.width / 2)
        }
        
        // MARK: - Subviews
        
        @ViewBuilder
        private func HeaderView() -> some View {
            if title != nil || showCloseButton {
                HStack(alignment: .center) {
                    if let title = title {
                        Text(title)
                            .font(.system(size: 12, weight: .medium))
                    }
                    Spacer()
                    if showCloseButton {
                        CloseButton()
                    }
                }
                .padding(.top, 12)
            }
        }
        
        @ViewBuilder
        private func MessageView() -> some View {
            if let message = message {
                Text(message)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .font(.system(.caption))
                    .padding(.bottom, (currentSpot != nil && totalSpotsCount > 1) ? 12 : 0)
            }
        }
        
        @ViewBuilder
        private func PaginationView() -> some View {
            if totalSpotsCount > 1, let current = currentSpot {
                HStack {
                    Text("\(current + 1)/\(totalSpotsCount)")
                        .font(.system(.caption))
                    Spacer()
                    PaginationButtons()
                }
                .padding(.bottom, 12)
            }
        }
        
        @ViewBuilder
        private func PaginationButtons() -> some View {
            if let current = currentSpot {
                HStack(spacing: 8) {
                    if current > 0 {
                        ArrowButton(image: imageArrowLeft) {
                            currentSpot = current - 1
                        }
                    }
                    if current < totalSpotsCount - 1 {
                        ArrowButton(image: imageArrowRight) {
                            currentSpot = current + 1
                        }
                    }
                }
            }
        }
        
        private func CloseButton() -> some View {
            Button(action: {
                onDismiss?()
                currentSpot = totalSpotsCount
            }) {
                imageClose
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 10, height: 10)
            }
            .font(.system(.title))
        }
        
        private func ArrowButton(image: Image, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                image
                    .resizable()
                    .frame(width: arrowSize, height: arrowSize)
            }
            .foregroundColor(.orange)
            .font(.system(.title))
        }
}

#Preview {
    ACECoachmarkContentView(
        title: "ABC",
        message: "DEF",
        showCloseButton: false,
        onDismiss: nil,
        currentSpot: .constant(0),
        totalSpotsCount: 1
    )
    .background(Color.purple)
}
