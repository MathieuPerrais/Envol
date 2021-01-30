//
//  HTTPLoader.swift
//  
//
//  Created by Mathieu Perrais on 10/22/20.
//

import Foundation

open class HTTPLoader {

    public var nextLoader: HTTPLoader? {
        willSet {
            guard nextLoader == nil else { fatalError("The nextLoader may only be set once") }
        }
    }

    public init() { }
    
    /// Load an HTTPTask that will eventually call its completion handler
    open func load(task: HTTPTask) {
        // Check if already cancelled and return the fail with reason: cancelled 
        guard !task.isCancelled else {
            task.fail(.cancelled)
            return
        }
        
        if let next = nextLoader {
            next.load(task: task)
        } else {
            // Last loader in chain is expecting a next one, it doesn't send the request to the server.
            task.fail(.cannotConnect)
        }
    }
    
    /// Reset the loader to its initial configuration
    open func reset(with group: DispatchGroup) {
        nextLoader?.reset(with: group)
    }
}

extension HTTPLoader {
    public final func reset(on queue: DispatchQueue = .main, completionHandler: @escaping () -> Void) {
        let group = DispatchGroup()
        self.reset(with: group)

        group.notify(queue: queue, execute: completionHandler)
    }
    
    public final func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) -> HTTPTask {
        let task = HTTPTask(request: request, completion: completion)
        load(task: task)
        return task
    }
}
