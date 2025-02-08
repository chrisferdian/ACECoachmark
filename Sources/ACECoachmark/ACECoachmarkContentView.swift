import SwiftUI

/// A SwiftUI view that displays a coachmark with a title, message, pagination, and navigation buttons.
///
/// This view helps guide users through a series of highlighted spots in an app.
/// It supports pagination, a close button, and customizable images for navigation.
public struct ACECoachmarkContentView: View {
    
    /// Title of the coachmark.
    var title: String?
    
    /// Message providing additional details.
    var message: String?
    
    /// Whether the close button should be shown.
    let showCloseButton: Bool
    
    /// Closure executed when the coachmark is dismissed.
    let onDismiss: (() -> Void)?
    
    /// Binding to track the current spot index.
    @Binding var currentSpot: Int?
    
    /// Total number of spots in the sequence.
    let totalSpotsCount: Int
    
    /// Custom image for the left navigation arrow.
    var imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill")
    
    /// Custom image for the right navigation arrow.
    var imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill")
    
    /// Custom image for the close button.
    var imageClose: Image = Image(systemName: "xmark")
    
    private let arrowSize: CGFloat = 16

    /// Initializes the `ACECoachmarkContentView`.
    /// - Parameters:
    ///   - title: Title of the coachmark.
    ///   - message: Message providing additional details.
    ///   - showCloseButton: Whether the close button should be shown.
    ///   - onDismiss: Closure executed when the coachmark is dismissed.
    ///   - currentSpot: Binding to track the current spot index.
    ///   - totalSpotsCount: Total number of spots in the sequence.
    ///   - imageArrowLeft: Custom image for the left navigation arrow.
    ///   - imageArrowRight: Custom image for the right navigation arrow.
    ///   - imageClose: Custom image for the close button.
    public init(
        title: String? = nil,
        message: String? = nil,
        showCloseButton: Bool = true,
        onDismiss: (() -> Void)? = nil,
        currentSpot: Binding<Int?> = .constant(nil),
        totalSpotsCount: Int = 1,
        imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill"),
        imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill"),
        imageClose: Image = Image(systemName: "xmark")
    ) {
        self.title = title
        self.message = message
        self.showCloseButton = showCloseButton
        self.onDismiss = onDismiss
        self._currentSpot = currentSpot
        self.totalSpotsCount = max(1, totalSpotsCount)
        self.imageArrowLeft = imageArrowLeft
        self.imageArrowRight = imageArrowRight
        self.imageClose = imageClose
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HeaderView()
            MessageView()
            PaginationView()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
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
            currentSpot = nil
        }) {
            imageClose
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 10, height: 10)
        }
    }
    
    private func ArrowButton(image: Image, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            image
                .resizable()
                .frame(width: arrowSize, height: arrowSize)
        }
        .foregroundColor(.orange)
    }
}

