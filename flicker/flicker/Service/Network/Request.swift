//
//  Request.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

import Foundation

protocol RequestType {
    var path: String { get }
    var method: String { get }
    var params: [[String : String]]? { get }
//    var encoding: ParameterEncoding { get }
}

enum Request: RequestType {
    
    case photos(text: String)
}

extension Request {
    private static let baseURL = "https://api.flickr.com/"
    private static let services = "services/rest"
    private static let apiKey = "5c615d9b89fc7888c09690065320607d"
    private static let searchMethod = "flickr.photos.search"
    
    var path: String {
        switch self {
            case .photos:
                return Self.baseURL + Self.services
        }
    }
    
    var params: [[String : String]]? {
        switch self {
            case .photos(let text):
                return [["api_key": Self.apiKey],
                         ["method": Self.searchMethod],
                           ["tags": "\(text)"],
                         ["format": "json"],
                 ["nojsoncallback": "true"],
                         ["extras": "media"],
                         ["extras": "url_sq"],
                         ["extras": "url_m"],
                       ["per_page": "20"],
                           ["page": "1"]]
        }
    }
    
    var method: String {
        switch self {
            case .photos:
                return "GET"
        }
    }
}
