//
//  Photo.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

import Foundation

struct PhotoListDTO: Decodable {
    let photos: PhotoDTO?
}
struct PhotoDTO: Decodable {
    let photo: [Photo]
}


struct Photo: Decodable {
    let id: String
    private let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "url_m"
    }
}

extension Photo {
    var photoURL: URL? {
        URL(string: url ?? "")
    }
}
