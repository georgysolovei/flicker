//
//  ViewController.swift
//  flicker
//
//  Created by Georgy Solovei on 13.11.21.
//

import UIKit

final class PhotoListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var notFoundContainer: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = PhotoListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = NSLocalizedString("Search photo", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        // Set up collection view
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = view.frame.width/2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        // Set up not found container
        notFoundContainer = UIView()
       
        let notFoundLabel = UILabel()
        notFoundLabel.text = NSLocalizedString("Nothing found yet", comment: "")
        notFoundLabel.textColor = .lightGray
        notFoundLabel.font = .systemFont(ofSize: 32)
       
        let notFoundImageView = UIImageView(image: #imageLiteral(resourceName: "search"))
        notFoundImageView.tintColor = .lightGray
        
        notFoundContainer.addSubview(notFoundLabel)
        notFoundContainer.addSubview(notFoundImageView)
        
        notFoundImageView.translatesAutoresizingMaskIntoConstraints = false
        notFoundImageView.topAnchor.constraint(equalTo: notFoundContainer.topAnchor).isActive = true
        notFoundImageView.centerXAnchor.constraint(equalTo: notFoundContainer.centerXAnchor).isActive = true
        
        notFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        notFoundLabel.bottomAnchor.constraint(equalTo: notFoundContainer.bottomAnchor).isActive = true
        notFoundLabel.centerXAnchor.constraint(equalTo: notFoundContainer.centerXAnchor).isActive = true
        notFoundLabel.topAnchor.constraint(equalTo: notFoundImageView.bottomAnchor, constant: 16).isActive = true
        notFoundLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        view.addSubview(notFoundContainer)
        notFoundContainer.translatesAutoresizingMaskIntoConstraints = false
        notFoundContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        notFoundContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        notFoundContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Set up activity indicator
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
 }

// MARK: - Collection view data source/delegate
extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        if let url = viewModel.photoArray[indexPath.row].photoURL {
            cell.imageView.load(url: url)
        }
        cell.config = viewModel.cellConfig(for: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let detailsViewController = DetailsViewController(viewModel: viewModel.detailsViewModel(for: indexPath.row))
        present(detailsViewController, animated: true)
        
        searchController.searchBar.resignFirstResponder()
    
        return false
    }
}


// MARK: - Search bar delegate
extension PhotoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            notFoundContainer.isHidden = false
            viewModel.resetData()
            collectionView.reloadData()
            return
        }
        Debounce<String>.input(searchText, comparedAgainst: searchBar.text ?? "", perform: { [weak self] _ in
            self?.activityIndicator.startAnimating()
            self?.notFoundContainer.isHidden = true
           
            self?.viewModel.loadData(text: searchText, completion: { [weak self] error in
                self?.activityIndicator.stopAnimating()
          
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.notFoundContainer.isHidden = !self.viewModel.photoArray.isEmpty
                
                if let error = error {
                    let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                                            message: error.description,
                                                            preferredStyle: .actionSheet)
                    alertController.addAction(.init(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: { [unowned self] _ in
                        self.dismiss(animated: true)
                    }))
                    self.present(alertController, animated: true)
                }
            })
        })
    }
}
