//
//  DetailView.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/06/02.
//

import UIKit

final class DetailView: UIView {
    let numberFormatter: NumberFormatter = NumberFormatter()
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return scrollView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .title3, weight: .semibold)
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .systemGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(for: .body, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .preferredFont(for: .body, weight: .semibold)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let pageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupSubviewStructures()
        setupLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviewStructures() {
        informationStackView.addArrangedSubview(nameLabel)
        informationStackView.addArrangedSubview(stockLabel)
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(pageLabel)
        mainStackView.addArrangedSubview(informationStackView)
        
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(bargainPriceLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainScrollView.addSubview(mainStackView)
        
        self.addSubview(mainScrollView)
    }
    
    func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            mainScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            mainScrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainScrollView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45)
        ])
        
        NSLayoutConstraint.activate([
            informationStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: informationStackView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stockLabel.trailingAnchor.constraint(equalTo: informationStackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bargainPriceLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
    func configureContents(product: Product?) {
        guard let product = product else {
            return
        }
        
        guard let currency = product.currency?.rawValue else {
            return
        }
        
        nameLabel.text = product.name
        stockLabel.text = "남은 수량 : \(numberFormatter.numberFormatString(for: Double(product.stock)))"
        priceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for:product.price))"
        
        if product.discountedPrice != .zero {
            guard let price = priceLabel.text else {
                return
            }
            priceLabel.textColor = .red
            priceLabel.attributedText = setTextAttribute(of: price, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            bargainPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for:product.bargainPrice))"
        }
        
        
        descriptionLabel.text = product.description
    }
    
    private func setTextAttribute(of target: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: target)
        attributedText.addAttributes(attributes, range: (target as NSString).range(of: target))
        return attributedText
    }
}
