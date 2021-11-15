//
//  PhotoListViewModel.swift
//  flicker
//
//  Created by Georgy Solovei on 14.11.21.
//

import Foundation

final class PhotoListViewModel {
    var photoArray: [Photo] = []
        
    func loadData(text: String, completion: @escaping () -> ()) {        
        NetworkService.photoList(text: text) { [weak self] result in
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
    
    func resetData() {
        photoArray = []
    }
    
    func cellConfig(for index: Int) -> PhotoCell.Config {
        let last = photoArray.count - 1
        let beforeLast = photoArray.count - 2
        
        switch index {
            case 0:
               return .startEven
            case 1:
                return .startOdd
            case beforeLast where beforeLast % 2 == 0:
                return .endEven
            case last where last % 2 != 0:
                return .endOdd
            case index where index % 2 != 0:
                return .odd
            case index where index % 2 == 0:
                return .even
            default:
                return .startEven
        }
    }
}
