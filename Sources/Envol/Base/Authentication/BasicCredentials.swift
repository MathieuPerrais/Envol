//
//  BasicCredentials.swift
//  
//
//  Created by Mathieu Perrais on 1/29/21.
//

import Foundation

public struct BasicCredentials: Hashable, Codable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

extension BasicCredentials: HTTPRequestOption {
    public static let defaultOptionValue: BasicCredentials? = nil
}
