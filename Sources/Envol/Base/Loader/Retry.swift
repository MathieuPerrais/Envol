//
//  File.swift
//  
//
//  Created by Mathieu Perrais on 1/29/21.
//

//import Foundation


// ---------------- TODO 


//All HTTPTasks received via the load(task:) method are duplicated before being passed on to the next loader in the chain. This is because that each task should be executed only once, and so multiple invocations of a request will require multiple tasks.
//We’ll need a way to remember which “duplicated” task corresponds to an original task.
//We’ll need a way to keep a list of all the tasks that are waiting to be retried, and the time at which they want to be started.
//Therefore we’ll need some sort of Timer-like mechanism to keep track of “when should the next task be started”.
//Cancellation will be a bit tricky, because the original task will be cancelled, but we’ll need a way to see that happening and forward the cancellation command on to any duplications.
//Don’t forget about resetting

//This rough outline illustrates the principle of the “automatically retrying” loader. As requests come in, they’re saved off to the side and duplicates are forwarded on down the chain. As the duplicates complete, the loader examines the response and figures out what it should do with it. If the request’s retry strategy indicates it should try again, then it enqueues the task for a future date. If not, it takes the result for the duplicate request and pretends it was the original response all along.


//// TODO: make all of this thread-safe
//public class Retry: HTTPLoader {
//    // the original tasks as received by the load(task:) method
//    private var originalTasks = Dictionary<UUID, HTTPTask>()
//
//    // the times at which specific tasks should be re-attempted
//    private var pendingTasks = Dictionary<UUID, Date>()
//
//    // the currently-executing duplicates
//    private var executingAttempts = Dictionary<UUID, HTTPTask>()
//
//    // the timer for notifying when it's time to try another attempt
//    private var timer: Timer?
//
//    public override func load(task: HTTPTask) {
//        let taskID = task.id
//        // we need to know when the original task is cancelled
//        task.addCancelHandler { [weak self] in
//            self?.cleanupFromCancel(taskID: taskID)
//        }
//
//        attempt(task)
//    }
//
//    /// Immediately attempt to load a duplicate of the task
//    private func attempt(_ task: HTTPTask) {
//        // overview: duplicate this task and
//        // 1. Create a new HTTPTask that invokes handleResult(_:for:) when done
//        // 2. Save this information into the originalTasks and executingAttempts dictionaries
//
//        let taskID = task.id
//        let thisAttempt = HTTPTask(request: task.request, completion: { [weak self] result in
//            self?.handleResult(result, for: taskID)
//        })
//
//        originalTasks[taskID] = task
//        executingAttempts[taskID] = thisAttempt
//
//        super.load(task: thisAttempt)
//    }
//
//    private func cleanupFromCancel(taskID: UUID) {
//        // when a task is cancelled:
//        // - the original task is removed
//        // - any executing attempt must be cancelled
//        // - any pending task must be removed AND explicitly failed
//        //   - this is a task that was stopped at this level, therefore
//        //     this loader is responsible for completing it
//
//        // TODO: implement this
//    }
//
//    private func handleResult(_ result: HTTPResult, for taskID: UUID) {
//        // schedule the original task for retrying, if necessary
//        // otherwise, manually complete the original task with the result
//
//        executingAttempts.removeValue(forKey: taskID)
//        guard let originalTask = originalTasks.removeValue(forKey: taskID) else { return }
//
//        if let delay = retryDelay(for: originalTask, basedOn: result) {
//            pendingTasks[taskID] = Date(timeIntervalSinceNow: delay)
//            rescheduleTimer()
//        } else {
//            originalTask.complete(with: result)
//        }
//    }
//
//    private func retryDelay(for task: HTTPTask, basedOn result: HTTPResult) -> TimeInterval? {
//        // we do not retry tasks that were cancelled or stopped because we're resetting
//        // TODO: return nil if the result indicates the task was cancelled
//        // TODO: return nil if the result indicates the task failed because of `.resetInProgress`
//
//        let strategy = task.request.retryStrategy
//        guard let delay = strategy?.retryDelay(for: result) else { return nil }
//        return max(delay, 0) // don't return a negative delay
//    }
//
//    private func rescheduleTimer() {
//        // TODO: look through `pendingTasks` find the task that will be retried soonest
//        // TODO: schedule the timer to fire at that time and call `fireTimer()`
//    }
//
//    private func fireTimer() {
//        // TODO: get the tasks that should've started executing by now and attempt them
//        // TODO: reschedule the timer
//    }
//
//    public override func reset(with group: DispatchGroup) {
//        // This loader is done resetting when all its tasks are done executing
//
//        for task in originalTasks.values {
//            group.enter()
//            task.addCompletionHandler { group.leave() }
//        }
//
//        super.reset(with: group)
//    }
//}

