//
//  ACEViewProperty.swift
//  ACECoachmark
//

import SwiftUI

struct ACEViewProperty : Sendable{
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
    static let defaultValue: [Int: ACEViewProperty] = [:]
    
    static func reduce(value: inout [Int: ACEViewProperty], nextValue: () -> [Int: ACEViewProperty]) {
        value.merge(nextValue()){$1}
    }
}
