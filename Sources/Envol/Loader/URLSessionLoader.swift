//
//  URLSessionLoader.swift
//  
//
//  Created by Mathieu Perrais on 10/23/20.
//

import Foundation

public class URLSessionLoader: HTTPLoader {
    
    var session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public override func load(task: HTTPTask) {
        
        let request = task.request
        
        guard let url = request.url else {
            // we couldn't construct a proper URL out of the request's URLComponents
            task.fail(.invalidRequest, error: HTTPRequestError.urlMissing)
            return
        }
        
        // construct the URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        // copy over any custom HTTP headers
        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }
        
        if request.body.isEmpty == false {
            // if our body defines additional headers, add them
            for (header, value) in request.body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }
            
            // attempt to retrieve the body data
            do {
                urlRequest.httpBody = try request.body.encode()
            } catch {
                // something went wrong creating the body; stop and report back
                task.fail(.bodyMalformed, error: error)
                return
            }
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            // construct a Result<HTTPResponse, HTTPError> out of the triplet of data, url response, and url error
            let result = HTTPResult(request: request, responseData: data, response: response, error: error)
            task.complete(with: result)
        }
        
        // if the HTTPTask is cancelled, also cancel the dataTask (this is the last Loader)
        task.addCancellationHandler {
            print("URLSessionLoader Cancellation handler: Cancelling the URLSession DataTask")
            dataTask.cancel()
        }
        
        // off we go!
        dataTask.resume()
    } 
}
