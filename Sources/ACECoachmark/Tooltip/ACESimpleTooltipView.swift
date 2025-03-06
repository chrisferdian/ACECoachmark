//
//  TooltipView.swift
//  ACECoachmark

import SwiftUI

struct ACESimpleTooltipView: View {
    let text: String
    let position: TooltipPosition

    var body: some View {
        Group {
            switch position {
            case .top:
                VStack(spacing: 0) {
                    textView()
                    arrowView()
                }
            case .bottom:
                VStack(spacing: 0) {
                    arrowView()
                    textView()
                }
            case .left:
                HStack(spacing: 0) {
                    textView()
                    arrowView()
                }
            case .right:
                HStack(spacing: 0) {
                    arrowView()
                    textView()
                }
            }
        }
        .background(Color.clear)
    }

    private func textView() -> some View {
        Text(text)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
            )
            .foregroundColor(.black)
    }

    private func arrowView() -> some View {
        Triangle()
            .fill(Color.white.opacity(0.8))
            .frame(width: 8, height: 8)
            .rotationEffect(rotation(for: position))
    }

    private func rotation(for position: TooltipPosition) -> Angle {
        switch position {
        case .top: return .degrees(180)
        case .bottom: return .degrees(0)
        case .left: return .degrees(90)
        case .right: return .degrees(-90)
        }
    }
}
