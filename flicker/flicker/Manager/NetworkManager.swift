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
 
    private let apiKey = "5c615d9b89fc7888c09690065320607d"
    private let apiSecret = "af7e2a7c2129367f"
    
    // Set up NetworkManager here
    private init() {

    }
    
    func request(_ request: RequestType, completion: @escaping (Result<Data, Error>) -> Void) {

    }
}
