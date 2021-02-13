//
//  Request.swift
//  
//
//  Created by Mathieu Perrais on 2/12/21.
//

import Foundation
import Combine

// This is a "business logic" request, higher level than the underlying HTTPRequest
// (think of it like a high level request of resource)
// Response can be anything at this stage but common type would be a Decodable model or a plain confirmation JSON
public struct Request<ResponseType> {
    public let underlyingRequest: HTTPRequest
    // Custom closure that does the decoding
    public let decode: (HTTPResponse) throws -> Response<ResponseType>

    public init(underlyingRequest: HTTPRequest, decode: @escaping (HTTPResponse) throws -> Response<ResponseType>) {
        self.underlyingRequest = underlyingRequest
        self.decode = decode
    }
}


/// If the `ResponseType` is `Decodable` we add an initializer that takes a `TopLevelDecoder` to do the transformation to the Decodable Model
extension Request where ResponseType: Decodable {
    
    // request a value that's decoded using a plain JSON decoder
    public init(underlyingRequest: HTTPRequest) {
        self.init(underlyingRequest: underlyingRequest, decoder: JSONDecoder())
    }
    
    // request a value that's decoded using the specified decoder
    // requires: import Combine
    public init<D: TopLevelDecoder>(underlyingRequest: HTTPRequest, decoder: D) where D.Input == Data {
        self.init(
            underlyingRequest: underlyingRequest,
            decode: { httpResponse in
                // Custom closure, just a call to decoding on the custom decoder we passed (closure can throw)
                let body = try httpResponse.validateBody(underlyingRequest: underlyingRequest)
                let bodyModel = try decoder.decode(ResponseType.self, from: body)
                
                return Response(httpResponse: httpResponse, body: bodyModel)
            }
        )
    }
}


/// If the `ResponseType` is `Decodable` we add an initializer that takes a `TopLevelDecoder` to do the transformation to the Decodable Model
extension Request where ResponseType == JSONDictionary {
    public init(underlyingRequest: HTTPRequest) {
        self.init(
            underlyingRequest: underlyingRequest,
            decode: { httpResponse in
                // Custom closure, we use built-in json deserialization to return the Dictionary
                let body = try httpResponse.validateBody(underlyingRequest: underlyingRequest)
                let bodyJSON = try JSONSerialization.jsonObject(with: body) as? JSONDictionary ?? [:]
            
                return Response(httpResponse: httpResponse, body: bodyJSON)
            }
        )
    }
}
