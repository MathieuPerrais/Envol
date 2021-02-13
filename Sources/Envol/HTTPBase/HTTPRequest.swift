//
//  HTTPRequest.swift
//  
//
//  Created by Mathieu Perrais on 10/19/20.
//

import Foundation

enum HTTPRequestError: Error {
    case urlMissing
}

public struct HTTPRequest {
    public let id = UUID()
    private var urlComponents = URLComponents()
    public var method: HTTPMethod = .get
    public var headers: [String: String] = [:] // Improve type later (case insensitivity)
    public var body: HTTPBody = EmptyBody()
    
    private var options = [ObjectIdentifier: Any]()
    
    public init(path: String = "", queryItems: [URLQueryItem]? = nil) {
        urlComponents.scheme = "https"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
    }
    
    public subscript<O: HTTPRequestOption>(option type: O.Type) -> O.Value {
        get {
            // create the unique identifier for this type as our lookup key
            let id = ObjectIdentifier(type)
            
            // pull out any specified value from the options dictionary, if it's the right type
            // if it's missing or the wrong type, return the defaultOptionValue
            guard let value = options[id] as? O.Value else { return type.defaultOptionValue }
            
            // return the value from the options dictionary
            return value
        }
        set {
            let id = ObjectIdentifier(type)
            // save the specified value into the options dictionary
            options[id] = newValue
        }
    }
}

public extension HTTPRequest {
    var scheme: String { urlComponents.scheme ?? "https" }
    
    var host: String? {
        get { urlComponents.host }
        set { urlComponents.host = newValue }
    }
    
    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }
    
    var query: [URLQueryItem]? {
        get { urlComponents.queryItems }
        set { urlComponents.queryItems = newValue }
    }
    
    var url: URL? {
        get { urlComponents.url }
    }
}

extension HTTPRequest {
    public var serverEnvironment: ServerEnvironment? {
        get { self[option: ServerEnvironment.self] }
        set { self[option: ServerEnvironment.self] = newValue }
    }
}

extension HTTPRequest {
    public var throttle: ThrottleOption {
        get { self[option: ThrottleOption.self] }
        set { self[option: ThrottleOption.self] = newValue }
    }
}

extension HTTPRequest {
    public var retryStrategy: HTTPRetryStrategy? {
        get { self[option: RetryOption.self] }
        set { self[option: RetryOption.self] = newValue }
    }
}

extension HTTPRequest {
    public var basicCredentials: BasicCredentials? {
        get { self[option: BasicCredentials.self] }
        set { self[option: BasicCredentials.self] = newValue }
    }
}
