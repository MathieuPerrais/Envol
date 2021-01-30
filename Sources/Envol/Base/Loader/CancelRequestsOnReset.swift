//
//  CancelRequestsOnReset.swift
//  
//
//  Created by Mathieu Perrais on 10/25/20.
//

import Foundation

public class CancelRequestsOnReset: HTTPLoader {
    private let queue = DispatchQueue(label: "com.mathieuperrais.envol.cancelrequestsonreset")
    private var currentTasks = [UUID: HTTPTask]()
    
    // We’ve established previously that we need the ability to “reset” a loader chain to provide semantics of “starting over from scratch”.
    // Part of “starting over” would be to cancel any in-flight requests that we have; we can’t “start over” and still have remnants of our previous stack still going on.
    //
    // The loader we build will therefore tie “cancellation” in with the concept of “resetting”:
    // when the loader gets a call to reset(), it’ll immediately cancel() any in-progress requests and only allow resetting to finish once all of those requests have completed.
    //
    //This means we’ll need to keep track of any requests that pass through us, and forget about them when they finish
    
    public override func load(task: HTTPTask) {
        queue.sync {
            let id = task.id
            currentTasks[id] = task
            task.addCompletionHandler { _ in
                self.queue.sync {
                    self.currentTasks[id] = nil
                }
            }
        }
        
        super.load(task: task)
    }
    
    public override func reset(with group: DispatchGroup) {
        group.enter() // indicate that we have work to do
        queue.async {
            // get the list of current tasks
            let copy = self.currentTasks
            self.currentTasks = [:]
            DispatchQueue.global(qos: .userInitiated).async {
                for task in copy.values {
                    // cancel the task
                    group.enter()
                    task.addCompletionHandler { _ in  group.leave() }
                    task.cancel()
                }
                group.leave()
            }
        }
        
        nextLoader?.reset(with: group)
    }
}
