//
//  TooltipExampleView.swift
//  ACECoachmark

import SwiftUI

struct TooltipExampleView: View {
    @State private var currentTooltipId: Int? = 2
    @State private var isTooltipVisible = false
    @State private var selectedDirection: ACETooltipPosition = .bottom

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // Dropdown to select tooltip direction
            Picker("Select Tooltip Direction", selection: $selectedDirection) {
                Text("Top").tag(ACETooltipPosition.top)
                Text("Bottom").tag(ACETooltipPosition.bottom)
                Text("Left").tag(ACETooltipPosition.left)
                Text("Right").tag(ACETooltipPosition.right)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Spacer()
            Button(action: {
                currentTooltipId = 0
            }) {
                VStack {
                    Text("tap!!!!!!!!!!")
                }
                .padding(4)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .addTooltip(
                id: 0,
                text: "Blood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasj ",
                position: .right
            )
            
            Spacer()
            
            Button(action: {
                currentTooltipId = 1
            }) {
                VStack {
                    Text("Blood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasj")
                }
                .padding(4)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .addTooltip(
                id: 1,
                text: "Blood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasj",
                position: .top
            )
            Spacer()
            HStack(alignment: .center, spacing: 16) {
                Button {
                    currentTooltipId = 2
                } label: {
                    Text("123456010")
                }
                .addTooltip(
                    id: 2,
                    text: "Blood sugar tested\nafter not eating for 8-12\n hours.",
                    position: .left
                )
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
        .applyTooltipLayer(currentId: $currentTooltipId) { text, position in
            ACESimpleTooltipView(text: text, position: position)
        }
    }
}

#Preview(body: {
    TooltipExampleView()
})
