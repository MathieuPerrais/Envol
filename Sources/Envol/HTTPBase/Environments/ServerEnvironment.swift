//
//  ServerEnvironment.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import Foundation

public struct ServerEnvironment: HTTPRequestOption {
    public var host: String
    public var pathPrefix: String
    public var headers: [String: String]
    public var queryItems: [URLQueryItem]
    
    public static let defaultOptionValue: ServerEnvironment? = nil

    public init(host: String, pathPrefix: String = "/", headers: [String: String] = [:], queryItems: [URLQueryItem] = []) {
        // make sure the pathPrefix starts with a /
        let prefix = pathPrefix.hasPrefix("/") ? "" : "/"
        
        self.host = host
        self.pathPrefix = prefix + pathPrefix
        self.headers = headers
        self.queryItems = queryItems
    }
}
