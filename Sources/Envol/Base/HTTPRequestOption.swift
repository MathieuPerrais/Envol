//
//  HTTPRequestOption.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import Foundation

public protocol HTTPRequestOption {
    associatedtype Value

    /// The value to use if a request does not provide a customized value
    static var defaultOptionValue: Value { get }
}
