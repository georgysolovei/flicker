//
//  NetworkManager.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

// Concrete Networking implementation.
// Doesn't know anything about higher level app logic/data.
// Must be replaceable

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    func request(_ request: RequestType, completion: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession.shared
        var urlComponents = URLComponents(string: request.path)!
      
        if let params = request.params {
            urlComponents.queryItems = []
            params.forEach { dict in
                if dict.count == 1 {
                    urlComponents.queryItems?.append(
                        URLQueryItem(name: dict.keys.first!, value: dict.values.first!)
                    )
                } else {
                    assertionFailure("Dictionary with parameters must contain one key-value pair")
                }
            }
        }
        guard let url = urlComponents.url else {
            assertionFailure("Failed to construct URL")
            return
        }
        var urlRequest = URLRequest(url: url, timeoutInterval: 30)
        urlRequest.httpMethod = request.method

        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                let mime = response.mimeType,
                    mime == "application/json",               // is mime type correct
                error == nil                                  // was there no error
            else {
                completion(.failure(error ?? CustomError.unknown))
                return
            }
            completion(.success(data))
        })
        task.resume()
    }
}

enum CustomError: Error {
    case unknown
}
