//
//  TooltipExampleView.swift
//  ACECoachmark

import SwiftUI
public struct RadioButton: View {
    let id: String
    let title: String
    let accessoryText: String?
    let isMarked: Bool
    let isDisabled: Bool
    let onSelected: (String) -> Void

    // swiftlint:disable:next function_default_parameter_at_end
    public init(
        id: String,
        title: String = "",
        accessoryText: String? = nil,
        isMarked: Bool,
        isDisabled: Bool = false,
        onSelected: @escaping (String) -> Void
    ) {
        self.id = id
        self.title = title
        self.accessoryText = accessoryText
        self.isMarked = isMarked
        self.isDisabled = isDisabled
        self.onSelected = onSelected
    }

    public var body: some View {
        Button {
            onSelected(self.id)
        } label: {
            HStack {
                Image(systemName: "info.circle")
                Text(title)
                if let accessoryText = accessoryText {
                    Spacer()
                    Text(accessoryText)
                }
            }
        }.disabled(isDisabled)
    }
}


struct TooltipExampleView: View {
    @State private var currentTooltipId: Int? = 4
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
            HStack(alignment: .center, spacing: 4) {
                HStack {
                    Button {
                        currentTooltipId = 4
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .addTooltip(
                        id: 4,
                        text: "Blood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasj",
                        position: .top
                    )
                    RadioButton(
                        id: "1",
                        title: "testing1",
                        isMarked: false,
                        isDisabled: false
                    ) { selected in
                        
                    }
                }

                HStack {
                    Button {
                        currentTooltipId = 5
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .addTooltip(
                        id: 5,
                        text: "Blood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasjBlood sugar tested\nafter not eating for 8-12\n hours. sdjajdjajd sjadsajdjasjd sajdjasjdasj",
                        position: .top
                    )
                    RadioButton(
                        id: "1",
                        title: "testing1",
                        isMarked: false,
                        isDisabled: false
                    ) { selected in
                        
                    }
                }
            }
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
