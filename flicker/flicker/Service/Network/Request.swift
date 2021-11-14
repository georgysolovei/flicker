//
//  Request.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

import Foundation

protocol RequestType {
    var path: String { get }
//    var method: String { get }
//    var params: Parameters? { get }
//    var encoding: ParameterEncoding { get }
}

enum Request: RequestType {
    case photos
    var path: String {
        ""
    }
}
