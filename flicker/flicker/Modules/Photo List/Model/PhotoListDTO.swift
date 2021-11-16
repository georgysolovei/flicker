//
//  PhotoListDTO.swift
//  flicker
//
//  Created by Georgy Solovei on 16.11.21.
//

import Foundation

struct PhotoListDTO: Decodable {
    let photos: PhotoDTO?
}
struct PhotoDTO: Decodable {
    let photo: [Photo]
}
