//
//  MockLoader.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import XCTest
@testable import Envol

//public class MockLoader: HTTPLoading {
//    // typealiases help make method signatures simpler
//    public typealias HTTPHandler = (HTTPResult) -> Void
//    public typealias MockHandler = (HTTPRequest, HTTPHandler) -> Void
//    
//    private var nextHandlers = Array<MockHandler>()
//    
//    public override func load(request: HTTPRequest, completion: @escaping HTTPHandler) {
//        if nextHandlers.isEmpty == false {
//            let next = nextHandlers.removeFirst()
//            next(request, completion)
//        } else {
//            let error = HTTPError(code: .cannotConnect, request: request)
//            completion(.failure(error))
//        }
//    }
//    
//    @discardableResult
//    public func then(_ handler: @escaping MockHandler) -> Mock {
//        nextHandlers.append(handler)
//        return self
//    }
//}
