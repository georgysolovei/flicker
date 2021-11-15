//
//  PhotoListViewModel.swift
//  flicker
//
//  Created by Georgy Solovei on 14.11.21.
//

import Foundation

final class PhotoListViewModel {
    var photoArray: [Photo] = []
    
    var isLoading = false
    
    func loadData(completion: @escaping () -> ()) {
        NetworkService.photoList { [weak self] result in
            switch result {
                case .success(let photoList):
                    self?.photoArray = photoList
                DispatchQueue.main.async {
                    completion()
                }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
