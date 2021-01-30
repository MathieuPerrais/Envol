//
//  ThrottleOption.swift
//  
//
//  Created by Mathieu Perrais on 1/28/21.
//

import Foundation

public enum ThrottleOption: HTTPRequestOption {
    public static var defaultOptionValue: ThrottleOption { .always }
    
    case always
    case never
}
