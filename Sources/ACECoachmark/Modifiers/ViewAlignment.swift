
//
//  ViewAlignmentPositionModifier.swift
//  ACECoachmark


import SwiftUI

struct ViewAlignmentModifier: ViewModifier {
    @Binding var horizontalPosition: HorizontalPosition
    @Binding var verticalPosition: VerticalPosition
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            updatePosition(for: geometry)
                        }
                        .onChange(of: geometry.frame(in: .global)) { _ in
                            updatePosition(for: geometry)
                        }
                }
            )
    }
    
    private func updatePosition(for geometry: GeometryProxy) {
        // Screen dimensions
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let maxX = geometry.frame(in: .global).maxX
        let maxY = geometry.frame(in: .global).maxY
        
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
}

extension View {
    func position(horizontal: Binding<HorizontalPosition>, vertical: Binding<VerticalPosition>) -> some View {
        self.modifier(ViewAlignmentModifier(horizontalPosition: horizontal, verticalPosition: vertical))
    }
}
