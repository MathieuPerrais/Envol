//
//  JSONBody.swift
//  
//
//  Created by Mathieu Perrais on 10/22/20.
//

import Foundation

public struct JSONBody: HTTPBody {
    public let isEmpty: Bool = false
    public var additionalHeaders = [
        "Content-Type": "application/json; charset=utf-8"
    ]
    
    private let encodeLogic: () throws -> Data
    
    // For encoding, we need to accept some generic value (the thing to encode), but it’d be nice to not have to make the entire struct generic to the encoded type.
    // We can avoid the type’s generic parameter by limiting it to the initializer, and then capturing the generic value in a closure.
    public init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) {
        self.encodeLogic = { try encoder.encode(value) }
    }
    
    public func encode() throws -> Data { return try encode() }
}
