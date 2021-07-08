//
//  ApplyEnvironment.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import Foundation

public class ApplyEnvironment: HTTPLoader {

    private var environment: ServerEnvironment

    public init(environment: ServerEnvironment) {
        self.environment = environment
        super.init()
    }
    
    public override func load(task: HTTPTask) {
        var copy = task.request
        
        // use the environment specified by the request, if it's present
        // if it doesn't have one, use the one passed to the initializer
        let requestEnvironment = task.request.serverEnvironment ?? environment

        if copy.host?.isEmpty ?? true { // Only if missing value (if specified by request, then we leave it)
            copy.host = requestEnvironment.host
        }
        
        // We add the prefix defined in the environment alongside the host for all API call (eg. "/api" for "/api/people)
        // then we add the custom path for that particular request ("/people") safely, making sure "/" is present
        let prefix = copy.path.hasPrefix("/") ? "" : "/"
        copy.path = requestEnvironment.pathPrefix + prefix + copy.path
        
        // Merge the headers from the environment (specific request headers have priority)
        copy.headers.merge(environment.headers) { (current, _) in current }
        
        // Merge the query items from the environment (specific request query items have priority)
        copy.mergeQueryItems(environment.queryItems, overwrite: false)
        
        task.updateRequest(copy)
        super.load(task: task)
    }
}
