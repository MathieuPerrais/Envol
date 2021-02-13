//
//  HTTPTask.swift
//  
//
//  Created by Mathieu Perrais on 10/25/20.
//

import Foundation
import SwiftTools

public class HTTPTask {
    public var id: UUID { request.id }
    public private(set) var request: HTTPRequest
    
    private let completion: (HTTPResult) -> Void
    
    private var _isCancelled = Atomic(false)
    public private(set) var isCancelled: Bool {
        get {
            return _isCancelled.value
        }
        set {
            _isCancelled.value { $0 = newValue }
        }
    }
    
    private var cancellationHandlers = SynchronizedArray<() -> Void>()
    private var completionHandlers = SynchronizedArray<(HTTPResult) -> Void>()

    public init(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        self.request = request
        self.completion = completion // Final client oriented Completion (not internal)
    }
    
    public func updateRequest(_ request: HTTPRequest) {
        print("""
            - HTTPTask: underlying HTTPRequest is being updated:
                OLD: \(self.request)
                NEW: \(request)
            """)
        self.request = request
    }
    
    public func addCompletionHandler(_ handler: @escaping (HTTPResult) -> Void) {
        completionHandlers.append(handler)
    }

    internal func addCancellationHandler(_ handler: @escaping () -> Void) {
        // if the task is already cancelled, HTTPLoader next() is not called, so no unnecessary blocks are added down the line
        cancellationHandlers.append(handler)
    }

    public func cancel() {
        isCancelled = true
        
        let handlers = cancellationHandlers
        cancellationHandlers = SynchronizedArray<() -> Void>()

        // invoke each handler in reverse order
        // we need to start with the final Loader that talks to the server
        // then move up the chain
        handlers.reversed().forEach { $0() }
    }

    public func complete(with result: HTTPResult) {
        // TODO: handle the case where the user has cancelled but this still comes in, what to do? it depends...
        // Maybe let's not return ERROR - Cancelled if it completed and came back from the server.
        // If it was a POST or a modifying request, then the client will think it didn't go through
        // Maybe if it wasn't cancelled in time, it should show as suceeded despite isCancelled == true??
//        if isCancelled == true {}
        
        let handlers = completionHandlers
        completionHandlers = SynchronizedArray<(HTTPResult) -> Void>()

        // invoke each handler in reverse order
        handlers.reversed().forEach { $0(result) }
        completion(result)
    }
    
    public func fail(_ errorCode: HTTPError.Code, error: Error? = nil) {
        let error = HTTPError(code: errorCode, request: request, underlyingError: error)
        complete(with: .failure(error))
    }
}
