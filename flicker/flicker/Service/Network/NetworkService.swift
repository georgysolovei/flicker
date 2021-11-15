//
//  NetworkService.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

// High level Network abstraction
// must not contain network implementation details

import Foundation

struct NetworkService {
    static func photoList(text: String, completion: @escaping (Result<[Photo], NetworkError>) -> Void) {
        let request = Request.photos(text: text)
        NetworkManager.shared.request(request) {
            completion(DataParser.photoList($0))
        }
    }
}
