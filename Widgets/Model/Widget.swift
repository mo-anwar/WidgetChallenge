//
//  Widget.swift
//  Widgets
//
//  Created by Mohamed anwar on 24/08/2023.
//

import Foundation

struct Widget: Codable, Hashable {
    let style: Style
    
    enum Style: String, Codable, Hashable {
        case large
        case square
        case mini
    }
}

extension [Widget] {
    var isLargeSection: Bool {
        allSatisfy({ $0.style == .large })
    }
    
    var isSquareSection: Bool {
        allSatisfy({ $0.style == .square })
    }
    
    var isSquareAndMiniSection: Bool {
        contains(where: { $0.style == .square }) && contains(where: { $0.style == .mini })
    }
    
    var isMiniSection: Bool {
        allSatisfy({ $0.style == .mini })
    }
}
