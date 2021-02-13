//
//  PrintInfo.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import Foundation

public class PrintInfo: HTTPLoader {

//    open override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
    public override func load(task: HTTPTask) {
        print("Loading \(task.request)")
        
        task.addCancellationHandler {
            print("Task cancelled: \(task)")
        }
        
        task.addCompletionHandler { result in
            print("Task Loaded: \(result)")
        }
        
        super.load(task: task)
    }
}
