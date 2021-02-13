//
//  Response.swift
//  
//
//  Created by Mathieu Perrais on 2/14/21.
//

import Foundation

/// This is a "business logic" Response
/// it includes the HTTPResponse to inspect status code, message, body Data or underlying HTTPURLResponse
/// it also includes a decoded Model object passed by Generic in its type (Response).
public struct Response<ResponseType> {
    public let httpResponse: HTTPResponse
    public let body: ResponseType
    
    /// A shortcut to access the underlying status. Equivalent to: .httpResponse.status
    public var status: HTTPStatus {
        return httpResponse.status
    }
}
