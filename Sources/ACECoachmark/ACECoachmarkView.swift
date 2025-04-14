//
//  ACeCoachmarkView.swift
//  ACECoachmark

import SwiftUI

struct ACECoachmarkView<Content: View>: View {
    private let TAG: String = "ACECoachmarkView"
    
    var imageArrowLeft: Image = Image(systemName: "chevron.left.circle.fill")
    var imageArrowRight: Image = Image(systemName: "chevron.forward.circle.fill")
    var arrowSize: CGFloat = 32
    var model: AceCoachmarkBaseModel
    var showCloseButton: Bool
    var highlightFrame: CGRect
    var totalSpotsCount: Int
    var isTapToDismiss: Bool
    var onDismiss: (() -> Void)?
    var cornerRadius: CGFloat = 0
    
    @Binding var currentSpot: Int?
    @State private var currentIndex: Int = 0
    @State private var horizontalPosition: HorizontalPosition = .none
    @State private var verticalPosition: VerticalPosition = .none
    @State private var yPosition: CGFloat = 0
    
    let content: (AceCoachmarkBaseModel, Bool, Binding<Int?>, Int, (() -> Void)?) -> Content
    @State private var tooltipSize: CGSize = .zero
    
    init(
        model: AceCoachmarkBaseModel,
        showCloseButton: Bool,
        highlightFrame: CGRect,
        totalSpotsCount: Int,
        currentSpot: Binding<Int?>,
        onDismiss: (() -> Void)?,
        tapToDismiss: Bool = true,
        targetViewCornerRadius: CGFloat,
        @ViewBuilder content: @escaping (AceCoachmarkBaseModel, Bool, Binding<Int?>, Int, (() -> Void)?) -> Content
    ) {
        self.model = model
        self.showCloseButton = showCloseButton
        self.highlightFrame = highlightFrame
        self._currentSpot = currentSpot
        self.totalSpotsCount = totalSpotsCount
        self.onDismiss = onDismiss
        self.isTapToDismiss = tapToDismiss
        self.cornerRadius = targetViewCornerRadius
        self.content = content
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
        tapToDismiss: Bool = true,
        targetViewCornerRadius: CGFloat,
        @ViewBuilder content: @escaping (AceCoachmarkBaseModel, Bool, Binding<Int?>, Int, (() -> Void)?) -> Content
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
        self.isTapToDismiss = tapToDismiss
        self.cornerRadius = targetViewCornerRadius
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Dimmed background
            Color.black.opacity(currentSpot == nil ? 0 : 0.6)
                .edgesIgnoringSafeArea(.all)
                .mask(
                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
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
                    if isTapToDismiss {
                        onDismiss?()
                        currentSpot = totalSpotsCount
                    }
                }
            VStack {
                if highlightFrame.maxY > UIScreen.main.bounds.height * 0.7 {
                    // Anchor near the bottom, content goes above
                    if horizontalPosition == .center {
                        Spacer()
                            .frame(maxHeight: highlightFrame.minY - tooltipSize.height - 24)
                        HStack {
                            contentWrapper
                            .padding(.horizontal, 16)
                        }
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.white)
                            .offset(x: arrowOffset, y: -4)
                    } else if horizontalPosition == .right {
                        Spacer()
                            .frame(maxHeight: highlightFrame.minY - tooltipSize.height - 24)
                        HStack {
                            Spacer()
                            contentWrapper
                            .padding(.horizontal, 16)
                        }
                        HStack {
                            Spacer()
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.white)
                                .offset(x: -32, y: -4)
                        }
                    } else if horizontalPosition == .left {
                        Spacer()
                            .frame(maxHeight: highlightFrame.minY - tooltipSize.height - 24)
                        HStack {
                            contentWrapper
                            .padding(.horizontal, 16)
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.white)
                                .offset(x: 32, y: -4)
                            Spacer()
                        }
                    }
                } else {
                    // Anchor near the top, content goes below
                    Spacer().frame(height: highlightFrame.maxY)
                    if horizontalPosition == .center {
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(.white)
                            .offset(x: arrowOffset, y: 4)
                        HStack {
                            Spacer()
                            contentWrapper
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
                            contentWrapper
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
                            contentWrapper
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .onAppear { updatePosition(for: highlightFrame) }
            .onChange(of: highlightFrame, perform: updatePosition)
        }
    }
    
    @ViewBuilder
    var contentWrapper: some View {
        content(model, showCloseButton, $currentSpot, totalSpotsCount, onDismiss)
            .readContentSize(onChange: { newSize in
                self.tooltipSize = newSize
            })
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
            yPosition = highlightFrame.minY
        case .none:
            yPosition = .zero
        }
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

struct CoachmarkExampleView: View {
    
    @State var currentCoachmark: Int?
    @State var currentTooltip: Int? = 0

    var body: some View {
//        NavigationView(content: {
        ScrollView {
            VStack {
                Button {
                    self.currentCoachmark = 0
                } label: {
                    Text("Start!!!")
                }
                .addCoachmark(
                    4,
                    model: AceCoachmarkModel(
                        title: "Title 3",
                        message: "Message 3"
                    )
                )
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Button {
                        self.currentTooltip = 0
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 16, height: 16)
                    }
                    .background(Color.purple)
                    .addTooltip(id: 0, text: "Blood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasj", position: .top)
                    Spacer()
//                    Color.red
                    Button {
                        currentTooltip = 1
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 16, height: 16)
                    }
                    .addTooltip(
                        id: 1,
                        text: "TestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting",
                        position: .top
                    )
                    Spacer()
                }
                HStack {
                    Color.red
                        .frame(height: 125)
                        .addCoachmark(
                            3,
                            model: AceCoachmarkModel(
                                title: "Title 3",
                                message: "Message 3"
                            )
                        )
                    Color.purple
                        .frame(height: 125)
                        .addCoachmark(
                            9,
                            model: AceCoachmarkModel(
                                title: "Title 3",
                                message: "Message 3"
                            )
                        )
                    Color.orange
                        .frame(height: 125)
                        .addCoachmark(
                            10,
                            model: AceCoachmarkModel(
                                title: "Title 3",
                                message: "Message 3"
                            )
                        )
                }
                
                HStack {
                    Color.orange
                        .addCoachmark(
                            0,
                            model: AceCoachmarkModel(
                                title: "Title 2",
                                message: "Blood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasj"
                            )
                        )
                    Color.blue
                        .addCoachmark(
                            1,
                            model: AceCoachmarkModel(
                                title: "Title 3",
                                message: "Message 3"
                            )
                        )
                    Color.orange
                        .addCoachmark(
                            2,
                            model: AceCoachmarkModel(
                                title: "Title 3",
                                message: "Message 3"
                            )
                        )
                }
                .frame(width: .infinity, height: 350)
                .addChildCoachmark(
                    8,
                    model: AceCoachmarkModel(
                        title: "7",
                        message: "Parent"
                    )
                )
                
                HStack {
                    Color.green
                        .frame(width: .infinity, height: 100)
                        .addCoachmark(
                            5,
                            model: AceCoachmarkModel(
                                title: "Title 1",
                                message: "Message 1"
                            )
                        )
                    Color.black
                        .frame(width: .infinity, height: 100)
                        .addCoachmark(
                            6,
                            model: AceCoachmarkModel(
                                title: "Title 1",
                                message: "Message 1"
                            )
                        )
                    Color.pink
                        .frame(width: 250, height: 44)
                        .cornerRadius(8)
                        .addCoachmark(
                            7,
                            model: AceCoachmarkModel(
                                title: "Title 1",
                                message: "Message 1"
                            ),
                            cornerRadius: 8
                        )
                }
            }
        }
//        })
        .applyTooltipLayer(
            currentId: $currentTooltip,
            content: { text, position in
                ACESimpleTooltipView(text: text, position: position)
            })
        .applyCoachmarkLayers(
            currentSpot: $currentCoachmark,
            isTapToDissmissEnable: false
        ) { model, showCloseButton, currentSpot, totalSpot, onDismiss in
            ACECoachmarkContentView(
                title: model.title,
                message: model.message,
                showCloseButton: showCloseButton,
                onDismiss: {
                    
                },
                currentSpot: currentSpot,
                totalSpotsCount: totalSpot
            )
        }
    }
}

#Preview {
    CoachmarkExampleView()
}
