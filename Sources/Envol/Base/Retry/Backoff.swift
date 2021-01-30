//
//  Backoff.swift
//  
//
//  Created by Mathieu Perrais on 1/29/21.
//

import Foundation

//public enum Backoff: HTTPRetryStrategy {
//    case immediately(maximumNumberOfAttempts: Int)
//    case constant(delay: TimeInterval, maximumNumberOfAttempts: Int)
//    case exponential(delay: TimeInterval, maximumNumberOfAttempts: Int)
//    
//    
//    func retryDelay(for result: HTTPResult) -> TimeInterval? {
//        switch self {
//        case .immediately(let maximumNumberOfAttempts):
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
//    
////    public static func immediately(maximumNumberOfAttempts: Int) -> Backoff
////    public static func constant(delay: TimeInterval, maximumNumberOfAttempts: Int) -> Backoff
////    public static func exponential(delay: TimeInterval, maximumNumberOfAttempts: Int) -> Backoff
//}
