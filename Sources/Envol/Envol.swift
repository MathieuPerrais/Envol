import Foundation

public struct MyEnvol {
    var text = "Hello, World!"
}

public class StarWarsAPI {
    private let loader: HTTPLoader
    
    public init(loader: HTTPLoader = URLSessionLoader()) {
        self.loader = loader
    }

    public func requestPeople(completion: @escaping () -> Void) -> HTTPTask {
        var r = HTTPRequest()
//        r.host = "swapi.dev"
        r.path = "/people"

        return loader.load(request: r) { result in
            completion()
        }
    }
}
