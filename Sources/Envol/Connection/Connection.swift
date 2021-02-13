//
//  Connection.swift
//  
//
//  Created by Mathieu Perrais on 2/12/21.
//

import Foundation
import Combine

public class Connection {

    private let loader: HTTPLoader

    public init(loader: HTTPLoader) {
        self.loader = loader
    }

    @discardableResult
    public func request<ResponseType>(_ request: Request<ResponseType>, completion: @escaping (Result<Response<ResponseType>, Error>) -> Void) -> HTTPTask {
        let task = HTTPTask(request: request.underlyingRequest, completion: { result in
            // HTTPResult
            switch result {
            case .success(let httpResponse):
                do {
                    let response = try request.decode(httpResponse)
                    completion(.success(response))
                } catch {
                    // something when wrong while deserializing
                    completion(.failure(error))
                }
                
            case .failure(let error):
                // something went wrong during transmission (couldn't connect, dropped connection, etc)
                completion(.failure(error))
            }
        })
        loader.load(task: task)
        
        return task
    }
}

extension Connection {
    // Future<...> is a Combine-provided type that conforms to the Publisher protocol
    public func publisher<ResponseType>(for request: Request<ResponseType>) -> Future<Response<ResponseType>, Error> {
        return Future { promise in
            self.request(request, completion: promise)
        }
    }

    // This provides a "materialized" publisher, needed by SwiftUI's View.onReceive(...) modifier
    public func materializedPublisher<ResponseType>(for request: Request<ResponseType>) -> Future<Result<Response<ResponseType>, Error>, Never> {
        return Future { promise in
            self.request(request, completion: { promise(.success($0)) })
        }
    }
}
