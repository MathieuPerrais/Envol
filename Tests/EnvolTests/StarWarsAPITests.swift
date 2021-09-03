//
//  StarWarsAPITests.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import XCTest
@testable import Envol



class StarWarsAPITests: XCTestCase {

    func test_200_OK_WithValidBody() {
        
        // Create an expectation for a  download task.
        let expectation = XCTestExpectation(description: "Star Wars API test_200_OK_WithValidBody loaded in time")
        
        let _ = StarWarsConnection.request(.peopleJSON(id: 1)) { (result) in
            switch result {
            case .success(let response):
                print(response.body)
                XCTAssert(response.status == HTTPStatus.ok, "Response status code is 200 as expected")
                expectation.fulfill()
                
            case .failure(let error):
                print(error)
                XCTFail("Request failure - error: \(error)")
            }
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    // TO FIX
//    func test_publisher_cancellable() {
//
//        // Create an expectation for a  download task.
//        let expectation = XCTestExpectation(description: "Star Wars API test_publisher_cancellable loaded in time")
//
//        let request = Request.peopleJSON(id: 1)
//
//        let cancellable = StarWarsConnection.publisher(for:request).sink { (completion) in
//            print(completion)
//        } receiveValue: { (response) in
//            print(response.body)
//        }
//
//        sleep(5)
//        cancellable.cancel()
//
//
//        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
//        wait(for: [expectation], timeout: 10.0)
//    }
    
    // --------- MOCKLOADER TODO ---------
    
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
