//
//  ImageSaverService.swift
//  flicker
//
//  Created by Georgy Solovei on 16.11.21.
//

import UIKit

final class ImageSaverService: NSObject {
    static let shared = ImageSaverService()
  
    private var completion: (Error?) -> () = {_ in }
    
    func writeToPhotoAlbum(image: UIImage, completion: @escaping (Error?) -> ()) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completion(error)
    }
}
