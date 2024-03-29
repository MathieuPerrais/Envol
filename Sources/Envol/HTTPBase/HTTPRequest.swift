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
    public var headers: [String: String] = [:] // Improve type later (case insensitivity) (Property wrapper forcing lowercase?)
    public var body: HTTPBody = EmptyBody()
    
    private var options = [ObjectIdentifier: Any]()
    
    public init(path: String = "", queryItems: [URLQueryItem]? = nil) {
        urlComponents.scheme = "https"
        urlComponents.path = path
        urlComponents.queryItems = queryItems
    }
    
    
    // Unlimited Request Options dictionary management
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

// Exposing the underlying URLRequest attributes
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
    
    var queryItems: [URLQueryItem]? {
        get { urlComponents.queryItems }
        set { urlComponents.queryItems = newValue }
    }
    
    var url: URL? {
        get { urlComponents.url }
    }
}

// Convenience for merging request attributes with the specific Environment attributes
extension HTTPRequest {
    /// Merge the Dictionary of Headers provided to the `headers` of the Request it is called on.
    /// - Parameters:
    ///   - headers: The Dictionary of Headers `[String: String]` to add to the current request
    ///   - overwrite: Boolean that indicates if the argument values should replace what is currently in the Request if there is a conflict
    mutating func mergeHeaders(_ headers: [String: String], overwrite: Bool = false) {
        // Merge the headers from the environment (specific request headers have priority)
        self.headers.merge(headers) { (original, new) in
            return overwrite ? new : original
        }
    }
    
    /// Merge the array of additional query items provided to the `queryItems` of the Request it is called on.
    /// - Parameters:
    ///   - queryItems: The Array of `URLQueryItem` to add to the current request
    ///   - overwrite: Boolean that indicates if the argument values should replace what is currently in the Request if there is a conflict
    mutating func mergeQueryItems(_ queryItems: [URLQueryItem], overwrite: Bool = false) {
        if overwrite == false {
            self.queryItems = (self.queryItems ?? [URLQueryItem]()) + queryItems.filter { queryItem in
                return !(self.queryItems?.contains { $0.name == queryItem.name } ?? false)
            }
        } else {
            self.queryItems?.removeAll(where: { item in
                return queryItems.contains { $0.name == item.name }
            })
            
            self.queryItems = (self.queryItems ?? [URLQueryItem]()) + queryItems
        }
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
