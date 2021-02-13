//
//  HTTPResult.swift
//  
//
//  Created by Mathieu Perrais on 10/19/20.
//

import Foundation

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

extension HTTPResult {
    public var request: HTTPRequest {
        switch self {
            case .success(let response): return response.request
            case .failure(let error): return error.request
        }
    }
    
    public var response: HTTPResponse? {
        switch self {
            case .success(let response): return response
            case .failure(let error): return error.response
        }
    }
    
    init(request: HTTPRequest, responseData: Data?, response: URLResponse?, error: Error?) {
        var httpResponse: HTTPResponse?
        if let r = response as? HTTPURLResponse {
            httpResponse = HTTPResponse(request: request, response: r, body: responseData ?? Data())
        }
        
        if let e = error as? URLError {
            let code: HTTPError.Code
            switch e.code {
            case .badURL: code = .invalidRequest
            case .unsupportedURL: code = .invalidRequest
            case .badURL: code = .invalidRequest
                
            case .cancelled: code = .cancelled
            case .timedOut: code = .timedOut
                
            case .cannotFindHost: code = .cannotConnect
            case .cannotConnectToHost: code = .cannotConnect
            case .networkConnectionLost: code = .cannotConnect
            case .notConnectedToInternet: code = .cannotConnect
            case .cannotLoadFromNetwork: code = .cannotConnect
                
            case .badServerResponse: code = .invalidResponse
            case .cannotParseResponse: code = .invalidResponse
                
            case .userAuthenticationRequired: code = .authenticationFailed
            case .userCancelledAuthentication: code = .authenticationFailed
                
            case .secureConnectionFailed: code = .insecureConnection
            case .serverCertificateHasBadDate: code = .insecureConnection
            case .serverCertificateUntrusted: code = .insecureConnection
            case .serverCertificateHasUnknownRoot: code = .insecureConnection
            case .serverCertificateNotYetValid: code = .insecureConnection
            case .clientCertificateRejected: code = .insecureConnection
            case .clientCertificateRequired: code = .insecureConnection
                
            case .cannotCreateFile: code = .fileError
            case .cannotOpenFile: code = .fileError
            case .cannotCloseFile: code = .fileError
            case .cannotWriteToFile: code = .fileError
            case .cannotRemoveFile: code = .fileError
            case .cannotMoveFile: code = .fileError
                
            default: code = .unknown
            }
            self = .failure(HTTPError(code: code, request: request, response: httpResponse, underlyingError: e))
        } else if let someError = error {
            // an error, but not a URL error
            self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: someError))
        } else if let r = httpResponse {
            // not an error, and an HTTPURLResponse
            self = .success(r)
        } else {
            // not an error, but also not an HTTPURLResponse
            self = .failure(HTTPError(code: .invalidResponse, request: request, response: nil, underlyingError: nil))
        }
    }
}

public struct HTTPError: Error {
    /// The high-level classification of this error
    public let code: Code
    
    /// The HTTPRequest that resulted in this error
    public let request: HTTPRequest
    
    /// Any HTTPResponse (partial or otherwise) that we might have
    public let response: HTTPResponse?
    
    /// If we have more information about the error that caused this, stash it here
    public let underlyingError: Error?
    
    init(code: Code, request: HTTPRequest, response: HTTPResponse? = nil, underlyingError: Error? = nil) {
        self.code = code
        self.request = request
        self.response = response
        self.underlyingError = underlyingError
    }
    
    public enum Code {
        case invalidRequest             // the HTTPRequest could not be turned into a URLRequest
        case cannotConnect              // some sort of connectivity problem
        case cancelled                  // the user cancelled the request
        case insecureConnection         // couldn't establish a secure connection to the server
        case invalidResponse            // the system did not receive a valid HTTP response
        case timedOut                   // Request is timed out
        case authenticationFailed       // user authentication malformed/missing/rejected...
        case resetInProgress            // The chain of loader is being reset
        case bodyMalformed              // The decoding of the Body Data failed
        case fileError                  // Error related to file
        case unknown                    // we have no idea what the problem is
    }
}
