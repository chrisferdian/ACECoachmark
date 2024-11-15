//
//  ViewPositionModifier.swift
//  ACECoachmark
//
import SwiftUI

struct ViewPositionModifier: ViewModifier {
    @Binding var position: CGRect
    @Binding var maxXPosition: HorizontalPosition
    @Binding var maxYPosition: VerticalPosition

    func body(content: Content) -> some View {
        VStack {
            content
                .position(horizontal: $maxXPosition, vertical: $maxYPosition)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                self.position = geometry.frame(in: .global)
                            }
                            .onChange(of: geometry.frame(in: .global)) { newFrame in
                                self.position = newFrame
                            }
                    }
                )
            
            Text("Horizontal: "+maxXPosition.rawValue)
            Text("Vertical: "+maxYPosition.rawValue)
            Text("x: \(position.minX)\ny: \(position.minY)\nwidth: \(position.width)\nheight: \(position.height)")
        }
    }
}

extension View {
    func positionBinding(_ position: Binding<CGRect>, _ hAxis: Binding<HorizontalPosition>, yAxis: Binding<VerticalPosition>) -> some View {
        self.modifier(ViewPositionModifier(position: position, maxXPosition: hAxis, maxYPosition: yAxis))
    }
}
