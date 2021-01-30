//
//  RetryOption.swift
//  
//
//  Created by Mathieu Perrais on 1/29/21.
//

import Foundation

// --------------------- TODO 
public enum RetryOption: HTTPRequestOption {
    // by default, HTTPRequests do not have a retry strategy, and therefore do not get retried
    public static var defaultOptionValue: HTTPRetryStrategy? { nil }
}
