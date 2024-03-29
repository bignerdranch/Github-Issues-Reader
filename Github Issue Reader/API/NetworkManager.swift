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
    // Kevin - "explicit"? What's explicit vs. implicit here?
    // Re: Kevin - we're kind of building in a layer of implicit code here if I understand it correctly. I used the word explicit to help convey the necessity of the codable protocol being qualified here.
    
    // the parameter to our completion handler is <T> so the return of this needs to be returnable in a wide variety of data return as long it's codable because we explicitly asked it to be.
    // " _ " in parameters is a "no-name" so that there less need for redundancy and is cleaner at call sites (i.e. line 23 IssueViewModel
    // completion- name of parameter. That's how we reference a closure in the code.
    // completion closure: Type called Result which itself is generic (same type as the original generic by request.)
    // We're building a new type in this line: (Result<T, Error>)
    // Kevin - Close, Result already exists as a type; we aren't building a new one. We're specifying a particular Success and Failure generic type inside Result
    // Re: Kevin - I realized that as we got further down into the class, the generics are being applied to the Success and the kind of data we allow to intake to be particular.
    
    // completion parameter type acceptance must type Result which is being told to be either the generic <T> or an Error. So this will accept both possible return types.
    // the completion closure itself returns "nothing" aka Void
    // escaping is essentially communicating to the user that the closure is going to have a "lifespan" - MarkDs rock analogy of it possibly being called at some point in the future.
    // It's important that the completion parameter is @escaping because we might fall off the bottom of request before we use it. "hey don't forget about me because we might use you later after you've been called"
    func request<T: Codable>(_ urlString: String,
                             type: T.Type,
                             completion: @escaping (Result<T, NetworkingError>) -> Void) {
        
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
            
            // if the URLSession has an Error return then the error will specifically give back a completion handler with a failure on the NetworkingError enum returning the specific case of unknown error code
            // .failure is a case on Result - how are we accessing that enum? Is that what our completion handler is doing for us on line 35? How do we know we need to wrap the NetworkingError enum within that? I would never have thought to wrap it! (That's what we're doing here, right?)
            // Kevin - Result is an enum, so once you have an instance of Result you can `switch` over it just like any other enum
            // Re: Kevin - Again, I embarrassingly realized this after digging a little.
            
            // *must return the specific Result type - aka error/failure
            // MarkD would have used a guard let here- why use an if let? There's no response for data here.
            // must be called once and only once- multiple bad, zero bad
            // general "do we get something back?" if yes, we passed this test and can move on to the more specific criteria below
            // Kevin - should really `return` after completion is called - that closure should only be called once
            if let error = error {
                completion(.failure(NetworkingError.unknown(error: error)))
            }
            
            // Check for a success response code
            // why is this constant guarded? - the response parameter type(?) is optional. struggling to understand how this code knows without it being explicitly declared that ` response = URLResponse? `
            // Kevin - `func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask`
            //          The compiler the second parameter of `completionHandler` is optional, shift click on response
            // guard let - "is designed to exit the current function, loop, or condition if the check fails, so any values you unwrap using it will stay around after the check." - Paul Hudson
            // best guess: *down cast type casting response to HTTPURLResponse saying if there is a status code between 200-300 then return the URLResponse (which should be a good URL)
            // Kevin - close, first response is downcasted to HTTPURLResponse, a subclass of URLResponse.
            //          This also works as a combined optional check, going from `URLResponse?` -> `HTTPURLResponse`
            //          The second part of the guard is a boolean check, if the `HTTPURLResponse.statusCode` is good (between 200 and 300 by spec)
            // no idea what ~= means! - a pattern matching thingy - does it equal anything within that range? == would be an exact equal, does the return fully give the range back? no, only one value within the range so we use ~=
            // MarkD brute force >= 200 <= 300
            // else/otherwise wrap it in this response status code with a specific Int to tell you what the bad response is.
            // why can't we do this all in one big if else statement
            // Kevin - we could, but we need to exit scope on failure. Guards let us to separate logic checks and fail
            //          without ending up with giant nested if statements. See - "pyramid of doom"
            // Re: Kevin - Ew.
            
            // a URLResponse has a subclass of HTTPURLResponse
            // .dataTask handler returns MUST be (Data?, URLResponse?, Error?) (optionals! which is being handled in the guard let statements)
            // (200...300) bad code- needs to be (200..<300) because a return of 300 is an error code!
            guard let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                // dangerous force downcasting ` as! `
                // optional downcasting ` as? ` in an if let with two branches of the completion(.failure) 1. report status code 2. panic button - then return
                // (response as! HTTPURLResponse) boils down to the HTTPURLResponse (or a crash with the current code) which has a data return of status code on the HTTPURLResponse type/class and then assign that to the property name statusCode
                let statusCode = (response as! HTTPURLResponse).statusCode
                // if our statusCode isn't returning our 200...300 range then we go through this completion handler to manage the rest of whatever statusCodes we may be receiving and then cycle out of the guard let at the return.
                completion(.failure(NetworkingError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            // Data is so vague even in the documentation. Slightly unsettled by this.
            // Kevin - "Data" is vague because it could be a string, it could be an image, it could be XML, it could be json transmitted as a string, each string could be encoded a different way.
            // if we don't get our data then we can return the .invalidData case for the user!
            // error, response, data
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return
            }
            
            // do try catch blocks - need to educate more on this.
            // "If an error is thrown by the code in the do clause, it’s matched against the catch clauses to determine which one of them can handle the error." - swift docs
            // so if we get an error returned to us in the "do" part of the block... we then ask our "catch" to further clarify the problem?
            // Kevin - yes, catch can clarify the problem... or you can leave it empty and ignore the problem.
            //          swift tries to push you into "doing the right thing", but it can't tell you what the right thing is.
            do {
                // does codeable not cover this?
                // JSONDecoder() Uses Codable to decode!
                let decoder = JSONDecoder()
                // "A value that determines how to decode a type’s coding keys from JSON keys." basically further clarification of how we want out JSON data to return and we want it in a Swift readable way e.g. fee_fi_fo_fum (snakeCase) Converts to: feeFiFoFum (camelCase)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // what's "try" doing here? It doesn't give me any documentation to work with. try, try?, try!
                // language key word "the code that follows me has declared that it can throw" either the code to the right is going to run and be successful OR it's going to fail and fall into the catch block below.
                // success is being defined as: decoder is being asked to decode itself and the return from data?
                // ` func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable ` so the .decode MUST have a ` try ` to return a throw and fulfill the .decode parameters expectations
                // .self is compiler required to give it a direction to work with what the generic is
                // ` from: ` is simply the parameter name Swift chose here.
                // ergo- decode will attempt to build the set and follow the instructions, if it can't then it will bail and throw to the catch block
                // Kevin - a do block means the code inside can throw. Multiple lines inside the do block can all throw
                //          and are visually distinct with try. It's so developers know what can actually throw
                let success = try decoder.decode(T.self, from: data)
                // if there is a successful return of data please use our success constant right above to give us the deets!
                completion(.success(success))
            } catch {
                
                // if none of the above works, panic button = a decoding failure!
                // the error we got from the ` try ` in the ` do ` block above, we're going to wrap it in our NetworkingError type and could get more clarifying information of the .decodingFailure at this point.
                completion(.failure(NetworkingError.decodingFailure(error: error)))
            }
            
        }
        // this is making the task actually do everything we are telling it to do in the above handler closure. Resume tells dataTask that it's clear and can actually do the work now.
        dataTask.resume()
    }
}

extension NetworkingManager {
    // NetworkManager request func may return an error and this is the enum managing those potential returns.
    // ` invalidURL ` and ` invalidData ` there's nothing to clarify further either it worked or it didn't
    // ` invalidStatusCode ` the caller may be able to manipulate things to try to fix the return
    // ` decodingFailure ` and ` unknown ` allowing someone to dig deeper and learn about the more specific Error(type) if they want but not forcing more than that type to return. 
    enum NetworkingError: Error {
        case invalidURL
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case decodingFailure(error: Error)
        case unknown(error: Error)

        var title: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .invalidStatusCode:
                return "Invalid Status Code"
            case .invalidData:
                return "Invalid Data"
            case .decodingFailure:
                return "Decoding Failure"
            case .unknown:
                return "Unknown"
            }
        }

        var description: String? {
            switch self {
            case .invalidURL:
                return nil
            case .invalidStatusCode(statusCode: let statusCode):
                return "\(statusCode)"
            case .invalidData:
                return nil
            case .decodingFailure(let error):
                return error.localizedDescription
            case .unknown(let error):
                return error.localizedDescription
            }
        }
    }
}
