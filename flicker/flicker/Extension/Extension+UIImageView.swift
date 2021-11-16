//
//  Extension+UIImageView.swift
//  flicker
//
//  Created by Georgy Solovei on 15.11.21.
//

import UIKit

extension UIImageView {
    private var activityIndicator: UIActivityIndicatorView? {
        subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView
    }
    
    func load(url: URL, activityIndicatorStyle: UIActivityIndicatorView.Style = .medium) {
        
        // Set up activity indicator
        if let activityIndicator = activityIndicator {
            (activityIndicator.startAnimating())
        } else  {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = activityIndicatorStyle
            activityIndicator.color = .systemBlue
            activityIndicator.startAnimating()
            
            addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
        // Load image
        image = nil
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.activityIndicator?.stopAnimating()
                    self?.image = image
                }
            }
        }
    }
}
