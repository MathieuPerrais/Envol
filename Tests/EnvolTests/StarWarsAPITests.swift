//
//  StarWarsAPITests.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import XCTest
@testable import Envol

extension ServerEnvironment {

    public static let development = ServerEnvironment(host: "swapi.dev", pathPrefix: "/api")
    public static let qa = ServerEnvironment(host: "qa-1.example.com", pathPrefix: "/api")
    public static let staging = ServerEnvironment(host: "api-staging.example.com", pathPrefix: "/api")
    public static let production = ServerEnvironment(host: "api.example.com", pathPrefix: "/api")

}

class StarWarsAPITests: XCTestCase {

    func test_200_OK_WithValidBody() {
        
        // Create an expectation for a  download task.
        let expectation = XCTestExpectation(description: "TEST")
        
        let loader: HTTPLoader! =
            ResetGuard() -->
            CancelRequestsOnReset() -->
            Throttle(maximumNumberOfRequests: 20) -->
            ApplyEnvironment(environment: .development) -->
            PrintInfo() -->
            URLSessionLoader(session: URLSession.shared)
        
        
        let task = StarWarsAPI(loader: loader).requestPeople {
            XCTAssert(true)
            
            expectation.fulfill()
        }
        
//        task.cancel()
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    
//    let mock = MockLoader()
//    lazy var api: StarWarsAPI = { StarWarsAPI(loader: mock) }()
//
//    func test_200_OK_WithValidBody() {
//        mock.then { request, handler in
//            XCTAssertEqual(request.path, "/api/people")
//            handler(.success(/* 200 OK with some valid JSON */))
//        }
//        api.requestPeople { ...
//            // assert that "StarWarsAPI" correctly decoded the response
//        }
//    }
//
//    func test_200_OK_WithInvalidBody() {
//        mock.then { request, handler in
//            XCTAssertEqual(request.path, "/api/people")
//            handler(.success(/* 200 OK but some mangled JSON */))
//        }
//        api.requestPeople { ...
//            // assert that "StarWarsAPI" correctly realized the response was bad JSON
//        }
//    }
//
//    func test_404() {
//        mock.then { request, handler in
//            XCTAssertEqual(request.path, "/api/people")
//            handler(.success(/* 404 Not Found */))
//        }
//        api.requestPeople { ...
//            // assert that "StarWarsAPI" correctly produced an error
//        }
//    }
//
//    func test_DroppedConnection() {
//        mock.then { request, handler in
//            XCTAssertEqual(request.path, "/api/people")
//            handler(.failure(/* HTTPError of some kind */))
//        }
//        api.requestPeople { ...
//            // assert that "StarWarsAPI" correctly produced an error
//        }
//    }
}
