//
//  ViewController.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private let viewModel = PhotoListViewModel()
    let search = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadData(completion: collectionView.reloadData)
    }
    
    private func setupUI() {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("Search photo", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        search.searchResultsUpdater = self
        navigationItem.searchController = search
        
        // Set up collection view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = view.frame.width/2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true        
    }
 }

// MARK: - Collection view data source/delegate
extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if let url = viewModel.photoArray[indexPath.row].photoURL {
            cell.imageView.load(url: url)
        }
        
        // Set up margins
        let last = collectionView.numberOfItems(inSection: 0) - 1
        let beforeLast = collectionView.numberOfItems(inSection: 0) - 2
        
        switch indexPath.item {
            case 0:
                cell.config = .startEven
            case 1:
                cell.config = .startOdd
            case beforeLast where beforeLast % 2 == 0:
                cell.config = .endEven
            case last where last % 2 != 0:
                cell.config = .endOdd
            case indexPath.item where indexPath.item % 2 != 0:
                cell.config = .odd
            case indexPath.item where indexPath.item % 2 == 0:
                cell.config = .even
            default: break
        }
        return cell
    }
}


// MARK: - Search bar delegate
extension PhotoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
    }
}
