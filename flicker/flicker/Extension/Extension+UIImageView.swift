//
//  Extension+UIImageView.swift
//  flicker
//
//  Created by Georgy Solovei on 15.11.21.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        
        // set up activity indicator
        if let activityIndicator = subviews.first(where: {$0 is UIActivityIndicatorView}) as? UIActivityIndicatorView {
            (activityIndicator.startAnimating())
        } else  {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.style = .medium
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.color = .systemBlue
            
            addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
            
        // Load image
        image = nil
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        (self?.subviews.first(where: { $0 is UIActivityIndicatorView}) as? UIActivityIndicatorView)?.stopAnimating()
                        self?.image = image
                    }
                }
            }
        }
    }
}
