import Foundation
@testable import Envol


// Configuration of Endpoints, Environments and Connections
enum StarWarsEndpoint {
    public static let development = ServerEnvironment(host: "swapi.dev", pathPrefix: "/api")
//    public static let production = ServerEnvironment(host: "api.example.com", pathPrefix: "/api")
}

private let mainLoader: HTTPLoader! = HTTPLoader.getDefault(serverEnvironment: StarWarsEndpoint.development)
let StarWarsConnection = Connection(loader: mainLoader)


// Definition of the Model
struct People: Decodable {
    let name: String
    let height: String
    let mass: String
}

// Extension of Request to add the convinience method to query the server.
extension Request where ResponseType == People {
    static func people(id: Int) -> Request<ResponseType> {
        let request = HTTPRequest(path: "/people/\(id)/")

        // because Person: Decodable, this will use the initializer that automatically provides a JSONDecoder to interpret the response
        return Request(underlyingRequest: request)
    }
}

extension Request where ResponseType == JSONDictionary {
    static func peopleJSON(id: Int) -> Request<ResponseType> {
        let request = HTTPRequest(path: "/people/\(id)/")

        // because Person: Decodable, this will use the initializer that automatically provides a JSONDecoder to interpret the response
        return Request(underlyingRequest: request)
    }
}

