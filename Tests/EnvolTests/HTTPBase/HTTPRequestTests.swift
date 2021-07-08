//
//  HTTPRequestTests.swift
//  
//
//  Created by Mathieu Perrais on 9/1/21.
//

import XCTest
@testable import Envol

class HTTPRequestTests: XCTestCase {

    func testMergeQueryItemsNoConflict() {
        var request = HTTPRequest(path: "/", queryItems:
                                    [URLQueryItem(name: "a", value: "valueA"),
                                     URLQueryItem(name: "b", value: "valueB")])
        
        let initialCount = request.queryItems?.count ?? 0
        
        let additionalQueryItems = [URLQueryItem(name: "c", value: "valueC"),
                                    URLQueryItem(name: "d", value: "valueD")]
        
        request.mergeQueryItems(additionalQueryItems)
        
        XCTAssert(request.queryItems?.count == (initialCount + additionalQueryItems.count), "QueryItems count is not equal to initial count + additional query items count")
        
        for additionalItem in additionalQueryItems {
            XCTAssertTrue(request.queryItems?.contains(additionalItem) ?? false, "Request's queryItems does not contain expected additional item: \(additionalItem)")
        }
    }
    
    func testMergeQueryItemsConflictNoOverwrite() {
        var request = HTTPRequest(path: "/", queryItems:
                                    [URLQueryItem(name: "a", value: "valueA"),
                                     URLQueryItem(name: "b", value: "valueB")])
        
        let initialCount = request.queryItems?.count ?? 0
        
        let duplicatedValue = URLQueryItem(name: "b", value: "valueB2")
        let additionalQueryItems = [URLQueryItem(name: "d", value: "valueD")]
        
        let itemsToMerge = additionalQueryItems + [duplicatedValue]
        
        request.mergeQueryItems(itemsToMerge, overwrite: false)
        
        XCTAssert(request.queryItems?.count == (initialCount + additionalQueryItems.count), "QueryItems count is not equal to initial count + additional query items count without duplicate")
        
        XCTAssertFalse(request.queryItems?.contains(duplicatedValue) ?? false, "Request's queryItems contains unexpected overwritten item:  \(duplicatedValue)")
    }
    
    func testMergeQueryItemsConflictForcedOverwrite() {
        var request = HTTPRequest(path: "/", queryItems:
                                    [URLQueryItem(name: "a", value: "valueA"),
                                     URLQueryItem(name: "b", value: "valueB")])
        
        let initialCount = request.queryItems?.count ?? 0
        
        let duplicatedValue = URLQueryItem(name: "b", value: "valueB2")
        let additionalQueryItems = [URLQueryItem(name: "c", value: "valueC")]
        
        let itemsToMerge = additionalQueryItems + [duplicatedValue]
        
        request.mergeQueryItems(itemsToMerge, overwrite: true)
        
        XCTAssert(request.queryItems?.count == (initialCount + additionalQueryItems.count), "QueryItems count is not equal to initial count + additional query items count without duplicate")
        
        XCTAssertTrue(request.queryItems?.contains(duplicatedValue) ?? false, "Request's queryItems does not contain expected overwritten item:  \(duplicatedValue)")
    }
}
