//
//  DtailsViewController.swift
//  flicker
//
//  Created by Georgy Solovei on 16.11.21.
//

import UIKit

final class DetailsViewController: UIViewController {
    private var imageView: UIImageView!
    private var saveButton: UIButton!
    
    private let viewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let url = viewModel.url {
            imageView.load(url: url, activityIndicatorStyle: .large)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Set up image view
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
    
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // Set up save button
        let saveButton = UIButton(type: .system, primaryAction: UIAction(title: "Button Title",
                                                                         handler: { [unowned self] _ in
            self.saveButtonTapped()
        }))

        saveButton.setTitle(NSLocalizedString("Save Image", comment: ""), for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 24)
        saveButton.setTitleColor(.white, for: .normal)
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func saveButtonTapped() {
        if let image = imageView.image {
            ImageSaverService.shared.writeToPhotoAlbum(image: image, completion: { [weak self] error in
                
                if let error = error {
                    let alertController = UIAlertController(title: NSLocalizedString("Failed to save image", comment: ""),
                                                            message: error.localizedDescription,
                                                            preferredStyle: .actionSheet)
                 
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                                     style: .destructive)
                    let settingsAction = UIAlertAction(title: NSLocalizedString("Go to Settings", comment: ""),
                                                       style: .cancel,
                                                       handler: { _ in
                        if UIApplication.shared.canOpenURL(URL(string:UIApplication.openSettingsURLString)!) {
                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                    })
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                  
                    self?.present(alertController, animated: true)
                } else {
                    let alertController = UIAlertController(title: NSLocalizedString("Success!", comment: ""),
                                                            message: NSLocalizedString("Image saved!", comment: ""),
                                                            preferredStyle: .actionSheet)
                    alertController.addAction(.init(title: NSLocalizedString("Close", comment: ""), style: .cancel, handler: { [unowned self] _ in
                        self?.dismiss(animated: true)
                    }))
                    self?.present(alertController, animated: true)
                }
            })
        }
    }
}
