//
//  ViewModelType.swift
//  Widgets
//
//  Created by Mohamed anwar on 24/08/2023.
//

import Foundation
import Combine

typealias AnyUIEvent<T> = AnySubject<T, Never>

extension AnyUIEvent {
    
    static func create<T>() -> AnyUIEvent<T> {
        return PassthroughSubject<T, Never>().eraseToAnySubject()
    }
    
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
