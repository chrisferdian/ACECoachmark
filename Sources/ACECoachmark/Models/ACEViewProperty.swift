//
//  ACEViewProperty.swift
//  ACECoachmark
//

import SwiftUI

struct ACEViewProperty {
    var anchor: Anchor<CGRect>
    var text: String = ""
}

struct ACEPreference: PreferenceKey {
    static let defaultValue: [Int: ACEViewProperty] = [:]
    
    static func reduce(value: inout [Int: ACEViewProperty], nextValue: () -> [Int: ACEViewProperty]) {
        value.merge(nextValue()){$1}
    }
}
