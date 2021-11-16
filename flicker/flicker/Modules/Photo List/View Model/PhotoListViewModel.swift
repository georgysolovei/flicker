//
//  PhotoListViewModel.swift
//  flicker
//
//  Created by Georgy Solovei on 14.11.21.
//

import Foundation

final class PhotoListViewModel {
    private(set) var photoArray: [Photo] = []
    
    private var text = ""
    
    func loadData(text: String, completion: @escaping (NetworkError?) -> ()) {
        self.text = text
        NetworkService.photoList(text: text) { [weak self] result in
            switch result {
                case .success(let photoList):
                    if self?.text.isEmpty == true {
                        self?.photoArray.removeAll()
                    } else {
                        self?.photoArray = photoList
                    }
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(error)
                    }
            }
        }
    }
    
    func resetData() {
        text = ""
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
    
    func detailsViewModel(for index: Int) -> DetailsViewModel {
        DetailsViewModel(url: photoArray[index].photoURL)
    }
}
