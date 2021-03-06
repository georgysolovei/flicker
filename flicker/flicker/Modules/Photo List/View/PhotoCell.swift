//
//  PhotoCell.swift
//  flicker
//
//  Created by Georgy Solovei on 14.11.21.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = "PhotoCell"
   
    enum Config {
        case startEven
        case startOdd
        case even
        case odd
        case endEven
        case endOdd
    }
    
    var config: Config = .startEven {
        didSet {
            setupConstraints()
        }
    }
    
    let imageView = UIImageView(frame: .zero)
    
    private lazy var topConstraint = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
    private lazy var bottomConstraint = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    private lazy var leadingConstraint = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    private lazy var trailingConstraint = imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        setupConstraints()
    }
    
    private func setupConstraints() {
        let isStart = config == .startOdd || config == .startEven
        let isEnd = config == .endOdd || config == .endEven
        let isOdd = config == .startOdd || config == .odd || config == .endOdd
        let isEven = config == .startEven || config == .even || config == .endEven
        let isMiddle = config == .odd || config == .even
        
        if isOdd {
            leadingConstraint.constant = 4
            trailingConstraint.constant = -8
        }
        
        if isEven {
            leadingConstraint.constant = 8
            trailingConstraint.constant = -4
        }
        
        if isMiddle {
            topConstraint.constant = 4
            bottomConstraint.constant = -4
            return
        }
        
        if isStart {
            topConstraint.constant = 8
            bottomConstraint.constant = -4
        }
        
        if isEnd {
            topConstraint.constant = 4
            bottomConstraint.constant = -8
        }
    }
}
