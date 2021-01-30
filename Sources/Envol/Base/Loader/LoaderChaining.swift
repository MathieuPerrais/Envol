//
//  LoaderChaining.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import Foundation

precedencegroup LoaderChainingPrecedence {
    higherThan: NilCoalescingPrecedence
    associativity: right
}

infix operator --> : LoaderChainingPrecedence

@discardableResult
public func --> (lhs: HTTPLoader?, rhs: HTTPLoader?) -> HTTPLoader? { // TODO: explore why it's optional here
    lhs?.nextLoader = rhs
    return lhs ?? rhs
}
