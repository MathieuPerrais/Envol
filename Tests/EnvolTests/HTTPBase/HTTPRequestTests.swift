//
//  HTTPRequestTests.swift
//  
//
//  Created by Mathieu Perrais on 9/1/21.
//

import XCTest
@testable import Envol

final class HTTPRequestTests: XCTestCase {
    
    var request: HTTPRequest!
    var initialQueryItemsCount: Int!
    var initialHeadersCount: Int!
    
    override func setUp() {
        request = HTTPRequest(path: "/", queryItems:
                                    [URLQueryItem(name: "a", value: "valueA"),
                                     URLQueryItem(name: "b", value: "valueB")])
        
        request.headers = ["header1": "value1",
                           "header2": "value2"]
        
        initialQueryItemsCount = request.queryItems?.count ?? 0
        initialHeadersCount = request.headers.count
    }
    
    // MARK: - Headers merge tests
    func testMergeHeadersNoConflict() {
        let additionalHeaders = ["header3": "value3",
                                 "header4": "value4"]
        
        request.mergeHeaders(additionalHeaders)
        XCTAssert(request.headers.count == (initialHeadersCount + additionalHeaders.count),
                  "Headers count is not equal to initial count + additional headers count")
        
        for (key, value) in additionalHeaders {
            XCTAssertTrue(request.headers[key] == value,
                          "Request's headers does not contain expected additional header: \(key + ":" + value)")
        }
    }
    
    func testMergeHeadersConflictNoOverwrite() {
        let additionalHeaders = ["header2": "value2B",
                                 "header4": "value4"]
        let headersInCommon = request.headers.keys.filter { additionalHeaders.keys.contains($0) }
        
        request.mergeHeaders(additionalHeaders, overwrite: false)
        XCTAssert(request.headers.count == (initialHeadersCount + additionalHeaders.count - headersInCommon.count),
                  "Headers count is not equal to initial count + additional headers count")
        
        for (key, value) in additionalHeaders {
            if headersInCommon.contains(key) {
                XCTAssertTrue(request.headers[key] != value,
                              "Request's headers does contain unexpected overwritten header: \(key + ":" + value)")
            } else {
                XCTAssertTrue(request.headers[key] == value,
                              "Request's headers does not contain expected additional header: \(key + ":" + value)")
            }
        }
    }
    
    func testMergeHeadersConflictForcedOverwrite() {
        let additionalHeaders = ["header2": "value2B",
                                 "header4": "value4"]
        let headersInCommon = request.headers.keys.filter { additionalHeaders.keys.contains($0) }
        
        request.mergeHeaders(additionalHeaders, overwrite: true)
        XCTAssert(request.headers.count == (initialHeadersCount + additionalHeaders.count - headersInCommon.count),
                  "Headers count is not equal to initial count + additional headers count")
        
        for (key, value) in additionalHeaders {
            XCTAssertTrue(request.headers[key] == value,
                          "Request's headers does not contain expected additional header: \(key + ":" + value)")
        }
    }

    // MARK: - Query Items merge tests
    func testMergeQueryItemsNoConflict() {
        
        let additionalQueryItems = [URLQueryItem(name: "c", value: "valueC"),
                                    URLQueryItem(name: "d", value: "valueD")]
        
        request.mergeQueryItems(additionalQueryItems)
        XCTAssert(request.queryItems?.count == (initialQueryItemsCount + additionalQueryItems.count),
                  "QueryItems count is not equal to initial count + additional query items count")
        
        for additionalItem in additionalQueryItems {
            XCTAssertTrue(request.queryItems?.contains(additionalItem) ?? false,
                          "Request's queryItems does not contain expected additional item: \(additionalItem)")
        }
    }
    
    func testMergeQueryItemsConflictNoOverwrite() {
        
        let duplicatedValue = URLQueryItem(name: "b", value: "valueB2")
        let additionalQueryItems = [URLQueryItem(name: "d", value: "valueD")]
        
        let itemsToMerge = additionalQueryItems + [duplicatedValue]
        
        request.mergeQueryItems(itemsToMerge, overwrite: false)
        XCTAssert(request.queryItems?.count == (initialQueryItemsCount + additionalQueryItems.count),
                  "QueryItems count is not equal to initial count + additional query items count without duplicate")
        
        XCTAssertFalse(request.queryItems?.contains(duplicatedValue) ?? false,
                       "Request's queryItems contains unexpected overwritten item:  \(duplicatedValue)")
    }
    
    func testMergeQueryItemsConflictForcedOverwrite() {
        
        let duplicatedValue = URLQueryItem(name: "b", value: "valueB2")
        let additionalQueryItems = [URLQueryItem(name: "c", value: "valueC")]
        
        let itemsToMerge = additionalQueryItems + [duplicatedValue]
        
        request.mergeQueryItems(itemsToMerge, overwrite: true)
        XCTAssert(request.queryItems?.count == (initialQueryItemsCount + additionalQueryItems.count),
                  "QueryItems count is not equal to initial count + additional query items count without duplicate")
        
        XCTAssertTrue(request.queryItems?.contains(duplicatedValue) ?? false,
                      "Request's queryItems does not contain expected overwritten item:  \(duplicatedValue)")
    }
}
