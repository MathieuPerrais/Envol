//
//  HTTPRetryStrategy.swift
//  
//
//  Created by Mathieu Perrais on 1/29/21.
//

import Foundation


/// Return a TimeInterval, the length of time in seconds to wait before sending the request again
/// nil means: don't retry, 0 means: "retry immediately"
public protocol HTTPRetryStrategy {
    func retryDelay(for result: HTTPResult) -> TimeInterval?
}
