//
//  Throttle.swift
//  
//
//  Created by Mathieu Perrais on 1/27/21.
//

import Foundation
import SwiftTools

public class Throttle: HTTPLoader {
    
    private var _maximumNumberOfRequests: Atomic<UInt> = Atomic(UInt.max)
    public private(set) var maximumNumberOfRequests: UInt {
        get {
            return _maximumNumberOfRequests.value
        }
        set {
            _maximumNumberOfRequests.value { $0 = newValue }
        }
    }

    private var executingRequests = SynchronizedDictionary<UUID, HTTPTask>()
    private var pendingRequests = SynchronizedArray<HTTPTask>()

    public init(maximumNumberOfRequests: UInt = UInt.max) {
        super.init()
        self.maximumNumberOfRequests = maximumNumberOfRequests
    }
    
    
    public override func load(task: HTTPTask) {
        if task.request.throttle == .never {
            startTask(task)
            return
        }
        
        if UInt(executingRequests.count) < maximumNumberOfRequests {
            startTask(task)
        } else {
            let id = task.id
            task.addCancellationHandler {
                if let index = self.pendingRequests.firstIndex(where: { $0.id == id }) {
                    self.pendingRequests.remove(at: index) { retrievedTask in
                        retrievedTask.fail(.cancelled)
                    }
                }
            }
            pendingRequests.append(task)
        }
    }
    
    public override func reset(with group: DispatchGroup) {
        // Empty all the groups to start clean, use dispatch group, maybe no need to call cancel if we have already cancel thing
        group.enter()
        group.enter()
        
        DispatchQueue.global(qos: .userInitiated).async {
            // get the list of current tasks
            self.pendingRequests.removeAll() { _ in
                group.leave()
            }
            self.executingRequests.removeAll() {
                group.leave()
            }
        }
        
        nextLoader?.reset(with: group)
    }

    private func startTask(_ task: HTTPTask) {
        let id = task.id
        executingRequests[id] = task
        task.addCompletionHandler { _ in
            self.executingRequests[id] = nil
            self.startNextTasksIfAble()
        }
        super.load(task: task)
    }

    private func startNextTasksIfAble() {
        while UInt(executingRequests.count) < maximumNumberOfRequests && pendingRequests.count > 0 {
            // we have capacity for another request, and more requests to start
            pendingRequests.removeFirst() { [weak self] next in
                self?.startTask(next)
            }
        }
    }
}
