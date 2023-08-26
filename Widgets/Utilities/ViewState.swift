//
//  ViewState.swift
//  Widgets
//
//  Created by Mohamed anwar on 24/08/2023.
//

import Foundation

enum ViewState: Equatable {
    case loading(isUserInteractionEnabled: Bool)
    case error(message: String)
    case idle
}
