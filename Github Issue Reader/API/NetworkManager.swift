//
//  NetworkManager.swift
//  Github Issue Reader
//
//  Created by Savannah Sosa on 8/31/22.
//

import Foundation

final class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private init() {}
    
    func request<T: Codable>(_ urlString: String,
                             type: T.Type,
                             completion: @escaping (Result<T, NetworkingError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
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
        
        dataTask.resume()
    }
}

extension NetworkingManager {
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
