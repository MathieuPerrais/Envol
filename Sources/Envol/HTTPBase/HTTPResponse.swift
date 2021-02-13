//
//  HTTPResponse.swift
//  
//
//  Created by Mathieu Perrais on 10/19/20.
//

import Foundation

public enum HTTPResponseError: Error {
    case emptyBodyModelDecodingFailed
}

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
    
    public func validateBody(underlyingRequest: HTTPRequest) throws -> Data {
        // Check if there is some Data in the body
        guard let body = body else {
            // Continue only if the status code is 204: No content
            if status == .noContent {
                return Data() // return a non optional data (empty)
            }
            
            // if we expected a body throw an exception
            throw HTTPError.init(code: HTTPError.Code.bodyMalformed,
                                 request: underlyingRequest,
                                 response: self,
                                 underlyingError: HTTPResponseError.emptyBodyModelDecodingFailed)
        }

        return body
    }
}
