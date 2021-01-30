//
//  ResetGuard.swift
//  
//
//  Created by Mathieu Perrais on 10/24/20.
//

import Foundation
import SwiftTools

public class ResetGuard: HTTPLoader {
    private var isResetting = Atomic(false)
    
    
    public override func load(task: HTTPTask) {
        if isResetting.value == false {
            super.load(task: task)
        } else {
            task.fail(.resetInProgress)
        }
    }
    
    public override func reset(with group: DispatchGroup) {
        if isResetting.value == true { return }
        guard let next = nextLoader else { return }
        
        group.enter()
        isResetting.value { $0 = true }
        next.reset {
            self.isResetting.value { $0 = false }
            group.leave()
        }
    }
}
