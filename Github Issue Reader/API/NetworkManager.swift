//
//  NetworkManager.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/31/22.
//

import Foundation

// 1 day
final class NetworkingManager {
    
    // static- something associated with the class and not an instance. Handy for creating a "singleton" instance. The intent of the shared property is so project wide . Classes exist at compile time, instances do not.
    // this is shorthand for NetworkingManager is doing memory *allocation .init.
    // non-static properties make the runtime-meta data bigger.
    static let shared = NetworkingManager()
    
    // shorthand NetworkingManager.init It's forcing everyone to go through the shared property because outside of this class we need to initialize the NetworkingManager class.
    // *slightly questionable code choice- not necessarily good practice- you need a very good reason to do this.
    private init() {}
    
    // generics: <T> we could call this function with any type.
    // <T: Codable> ONLY TYPES THAT EXPLICITLY ADOPT CODABLE CAN BE USED HERE.
    // the parameter to our completion handler is <T> so the return of this needs to be returnable in a wide variety of data return as long it's codable because we explicitly asked it to be.
    // " _ " in parameters is a "no-name" so that there less need for redundancy and is cleaner at call sites (i.e. line 23 IssueViewModel
    // completion- name of parameter. That's how we reference a closure in the code.
    // completion closure: Type called Result which itself is generic (same type as the original generic by request.)
    // We're building a new type in this line: (Result<T, Error>)
    // completion parameter type acceptance must type Result which is being told to be either the generic <T> or an Error. So this will accept both possible return types.
    // the completion closure itself returns "nothing" aka Void
    // escaping is essentially communicating to the user that the closure is going to have a "lifespan" - MarkDs rock analogy of it possibly being called at some point in the future.
    // It's important that the completion parameter is @escaping because we might fall off the bottom of request before we use it. "hey don't forget about me because we might use you later after you've been called"
    func request<T: Codable>(_ urlString: String,
                             type: T.Type,
                             completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        // URLRequest two properties- load and the policies used to load it. Represents information about the request- must be used with a class (typically URLSession -pretty tightly coupled.)
        // validating the url is semi-trustworthy in design via the property above (line 37) and then wrap it in our URLRequest for policies etc
        
        // look into URLSessionConfiguration !!!
        let request = URLRequest(url: url)
        // there's a flavor where you can do "try await"
        // URLSession can cache - if somethings funky caching look URLRequest policies.
        // if you want more control you can use URLSessionConfiguration
        // URLSession will take the Request and the Configuration and then mash them together to get what it needs for data return.
        // handler - in a parameters, "under the rock" using the trailing closure syntax which is going to "handle" the information once it's needed. It's not until URLSession finishes with all it's work that we pull it out from under the rock with the handler to manage the return of data/information.
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(NetworkingError.unknown(error: error)))
            }
            
            // Check for a success response code
            guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let success = try decoder.decode(T.self, from: data)
                completion(.success(success))
            } catch {
                completion(.failure(NetworkingError.decodingFailure(error: error)))
            }
            
        }
        // this is making the task actually do everything we are telling it to do in the above handler closure. Resume tells dataTask that it's clear and can actually do the work now.
        dataTask.resume()
    }
}

extension NetworkingManager {
    // NetworkManager request func may return an error and this is the enum managing those potential returns.
    enum NetworkingError: Error {
        case invalidURL
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case decodingFailure(error: Error)
        case unknown(error: Error)
    }
}
