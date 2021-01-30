//
//  HTTPResponse.swift
//  
//
//  Created by Mathieu Perrais on 10/19/20.
//

import Foundation

public struct HTTPResponse {
    public let request: HTTPRequest
    private let response: HTTPURLResponse
    public let body: Data?
    
    public var status: HTTPStatus {
        // A struct of similar construction to HTTPMethod
        HTTPStatus(rawValue: response.statusCode)
    }

    public var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var headers: [AnyHashable: Any] { response.allHeaderFields } // Improve type later (case insensitivity)
    
    init(request: HTTPRequest, response: HTTPURLResponse, body: Data? = nil) {
        self.request = request
        self.response = response
        self.body = body
    }
}
