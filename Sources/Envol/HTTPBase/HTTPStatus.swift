//
//  HTTPStatus.swift
//  
//
//  Created by Mathieu Perrais on 10/22/20.
//

import Foundation

public struct HTTPStatus: Hashable {
    // Information responses
    public static let `continue` = HTTPStatus(rawValue: 100)
    public static let switchingProtocol = HTTPStatus(rawValue: 101)
    public static let processing = HTTPStatus(rawValue: 102)
    public static let earlyHints = HTTPStatus(rawValue: 103)
    
    // Successful responses
    public static let ok = HTTPStatus(rawValue: 200)
    public static let created = HTTPStatus(rawValue: 201)
    public static let accepted = HTTPStatus(rawValue: 202)
    public static let nonAuthoritativeInformation = HTTPStatus(rawValue: 203)
    public static let noContent = HTTPStatus(rawValue: 204)
    public static let resetContent = HTTPStatus(rawValue: 205)
    public static let partialContent = HTTPStatus(rawValue: 206)
    public static let multiStatus = HTTPStatus(rawValue: 207)
    public static let alreadyReporteds = HTTPStatus(rawValue: 208)
    public static let imUsed = HTTPStatus(rawValue: 226)
    
    // Redirection responses
    public static let multipleChoice = HTTPStatus(rawValue: 300)
    public static let movedPermanently = HTTPStatus(rawValue: 301)
    public static let found = HTTPStatus(rawValue: 302)
    public static let seeOther = HTTPStatus(rawValue: 303)
    public static let notModified = HTTPStatus(rawValue: 304)
    public static let temporaryRedirect = HTTPStatus(rawValue: 307)
    public static let permanentRedirect = HTTPStatus(rawValue: 308)
    
    // Client error responses
    public static let badRequest = HTTPStatus(rawValue: 400)
    public static let unauthorized = HTTPStatus(rawValue: 401)
    public static let paymentRequired = HTTPStatus(rawValue: 402)
    public static let forbidden = HTTPStatus(rawValue: 403)
    public static let notFound = HTTPStatus(rawValue: 404)
    public static let methodNotAllowed = HTTPStatus(rawValue: 405)
    public static let notAcceptable = HTTPStatus(rawValue: 406)
    public static let proxyAuthenticationRequired = HTTPStatus(rawValue: 407)
    public static let requestTimeout = HTTPStatus(rawValue: 408)
    public static let conflict = HTTPStatus(rawValue: 409)
    public static let gone = HTTPStatus(rawValue: 410)
    public static let lengthRequired = HTTPStatus(rawValue: 411)
    public static let preconditionFailed = HTTPStatus(rawValue: 412)
    public static let payloadTooLarge = HTTPStatus(rawValue: 413)
    public static let uriTooLong = HTTPStatus(rawValue: 414)
    public static let unsupportedMediaType = HTTPStatus(rawValue: 415)
    public static let rangeNotSatisfiable = HTTPStatus(rawValue: 416)
    public static let expectationFailed = HTTPStatus(rawValue: 417)
    public static let imATeapot = HTTPStatus(rawValue: 418)
    public static let misdirectedRequest = HTTPStatus(rawValue: 421)
    public static let unprocessableEntity = HTTPStatus(rawValue: 422)
    public static let locked = HTTPStatus(rawValue: 423)
    public static let failedDependency = HTTPStatus(rawValue: 424)
    public static let tooEarly = HTTPStatus(rawValue: 425)
    public static let upgradeRequired = HTTPStatus(rawValue: 426)
    public static let preconditionRequired = HTTPStatus(rawValue: 428)
    public static let tooManyRequests = HTTPStatus(rawValue: 429)
    public static let requestHeaderFieldsTooLarge = HTTPStatus(rawValue: 431)
    public static let unavailableForLegalReasons = HTTPStatus(rawValue: 451)
    
    // Server error responses
    public static let internalServerError = HTTPStatus(rawValue: 500)
    public static let notImplemented = HTTPStatus(rawValue: 501)
    public static let badGateway = HTTPStatus(rawValue: 502)
    public static let serviceUnavailable = HTTPStatus(rawValue: 503)
    public static let gatewayTimeout = HTTPStatus(rawValue: 504)
    public static let httpVersionNotSupported = HTTPStatus(rawValue: 505)
    public static let variantAlsoNegotiates = HTTPStatus(rawValue: 506)
    public static let InsufficientStorage = HTTPStatus(rawValue: 507)
    public static let LoopDetected = HTTPStatus(rawValue: 508)
    public static let notExtended = HTTPStatus(rawValue: 510)
    public static let networkAuthenticationRequired = HTTPStatus(rawValue: 511)
    
    public let rawValue: Int
}
