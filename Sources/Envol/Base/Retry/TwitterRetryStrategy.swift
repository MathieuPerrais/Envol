//
//  File.swift
//  
//
//  Created by Mathieu Perrais on 1/29/21.
//


////////// ----  Uncompiled example of custom strategy for a specific service leveraging the return codes and right retry delays.

//import Foundation
//
//struct TwitterRetryStrategy: HTTPRetryStrategy {
//    func retryDelay(for result: HTTPResult) -> TimeInterval? {
//        // TODO: are there other scenarios to consider?
//        guard let response = result.response else { return nil }
//
//        switch response.statusCode {
//
//            case 429:
//                // look for the header that tells us when our limit resets
//                guard let retryHeader = response.headers["x-rate-limit-reset"] else { return nil }
//                guard let resetTime = TimeInterval(retryHeader) else { return nil }
//                let resetDate = Date(timeIntervalSince1970: resetTime)
//                let timeToWait = resetDate.timeIntervalSinceNow()
//                guard timeToWait >= 0 else { return nil }
//                return timeToWait
//
//            case 503:
//                // look for the header that tells us how long to wait
//                guard let retryHeader = response.headers["retry-after"] else { return nil }
//                return TimeInterval(retryHeader)
//
//            default:
//                return nil
//        }
//    }
//}
