//
//  DetailCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/31.
//

import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViewStructure()
        setUpLayoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViewStructure() {
        mainStackView.addArrangedSubview(imageView)
        contentView.addSubview(mainStackView)
    }
    
    func setUpLayoutConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

extension DetailCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
