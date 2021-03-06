//
//  DataParser.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

import Foundation

struct DataParser {
    static func photoList(_ networkResult: Result<Data, Error>) -> (Result<[Photo], NetworkError>) {
        switch networkResult {
            case .success(let data):
                do {
                    let photoListObject: PhotoListDTO = try decode(from: data)
                    return .success(photoListObject.photos?.photo ?? [])
                } catch {
                    print(error)
                    return .failure(.dataValidation)
                }
            case .failure(_):
                // Parse network errors here and translate them
                // into app custom errors
                return .failure(.networkProblem)
        }
    }
    
    private static func decode<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        let decodableObject = try decoder.decode(T.self, from: data)
        return decodableObject
    }
}
