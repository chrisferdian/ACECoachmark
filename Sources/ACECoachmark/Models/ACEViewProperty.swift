//
//  ACEViewProperty.swift
//  ACECoachmark
//

import SwiftUI

struct ACEViewProperty : Sendable{
    var id: Int
    var anchor: Anchor<CGRect>
    var text: AceCoachmarkBaseModel
    var corderRadius: CGFloat?
}
public protocol AceCoachmarkBaseModel: Sendable {
    var title: String? { get }
    var message: String? { get }
}

public struct AceCoachmarkModel: AceCoachmarkBaseModel {
    public var title: String?
    public var message: String?
    
    public init(title: String? = nil, message: String? = nil) {
        self.title = title
        self.message = message
    }
}

struct ACEPreference: PreferenceKey {
    static let defaultValue: [ACEViewProperty] = []

    static func reduce(value: inout [ACEViewProperty], nextValue: () -> [ACEViewProperty]) {
        value.append(contentsOf:nextValue())
    }
}
struct ACEChildPreference: PreferenceKey {
    static let defaultValue: [ACEViewProperty] = []

    static func reduce(value: inout [ACEViewProperty], nextValue: () -> [ACEViewProperty]) {
        value.append(contentsOf:nextValue())
    }
}
