//
//  NetworkError.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

import Foundation

enum NetworkError: Error {
    case dataValidation
    case networkProblem
    
    var description: String {
        switch self {
            case .dataValidation:
                return NSLocalizedString("Wrong data", comment: "")
            case .networkProblem:
                return NSLocalizedString("Network or server problem", comment: "")
        }
    }
}
