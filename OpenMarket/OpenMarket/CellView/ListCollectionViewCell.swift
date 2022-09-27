//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewListCell, OpenMarketCellProtocol {
    
    var productNameLabel: UILabel = UILabel()
    var productImageView: UIImageView = UIImageView()
    var productPriceLabel: UILabel = UILabel()
    var productBargainPriceLabel: UILabel = UILabel()
    var productStockLabel: UILabel = UILabel()
    var mainStackView: UIStackView = UIStackView()
    var priceStackView: UIStackView = UIStackView()
    var informationStackView: UIStackView = UIStackView()
    var nameStockStackView: UIStackView = UIStackView()
    
    private let numberFormatter = NumberFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViewElements()
        setUpSubViewStructure()
        setUpLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViewElements() {
        productNameLabel = createLabel(
            font: .preferredFont(forTextStyle: .headline),
            textColor: .black,
            alignment: .natural
        )
        productPriceLabel = createLabel(
            font: .preferredFont(forTextStyle: .subheadline),
            textColor: .systemGray,
            alignment: .left
        )
        productBargainPriceLabel = createLabel(
            font: .preferredFont(forTextStyle: .subheadline),
            textColor: .systemGray,
            alignment: .left
        )
        productStockLabel = createLabel(
            font: .preferredFont(forTextStyle: .subheadline),
            textColor: .systemGray,
            alignment: .right
        )
        productImageView = createImageView(contentMode: .scaleAspectFit)
        mainStackView = createStackView(
            axis: .horizontal,
            alignment: .top,
            distribution: .fillProportionally,
            spacing: 5,
            margin: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        )
        informationStackView = createStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .fillEqually,
            spacing: 0
        )
        nameStockStackView = createStackView(
            axis: .horizontal,
            alignment: .leading,
            distribution: .fill,
            spacing: 0
        )
        priceStackView = createStackView(
            axis: .horizontal,
            alignment: .leading,
            distribution: .fill,
            spacing: 5
        )
        
        productNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        productStockLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        productNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        productStockLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        productPriceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        productBargainPriceLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    func setUpSubViewStructure() {
        nameStockStackView.addArrangedSubview(productNameLabel)
        nameStockStackView.addArrangedSubview(productStockLabel)
        
        priceStackView.addArrangedSubview(productPriceLabel)
        priceStackView.addArrangedSubview(productBargainPriceLabel)
        
        informationStackView.addArrangedSubview(nameStockStackView)
        informationStackView.addArrangedSubview(priceStackView)
        
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(informationStackView)
        
        contentView.addSubview(mainStackView)
    }
    
    func setUpLayoutConstraints() {
        NSLayoutConstraint.activate([
            informationStackView.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, constant: -10),
            productImageView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.15)
        ])
    }
    
    func configureCellContents(product: Product) {
        guard let currency = product.currency?.rawValue else {
            return
        }
        productNameLabel.text = product.name
        productPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for: product.price))"
        productImageView.requestImageDownload(url: product.thumbnail)
        guard let price = productPriceLabel.text else {
            return
        }
        
        if product.discountedPrice != .zero {
            productBargainPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for: product.bargainPrice))"
            productPriceLabel.textColor = .red
            productPriceLabel.attributedText = setTextAttribute(
                of: price,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        }
        if product.stock == .zero {
            productStockLabel.text = "품절"
            productStockLabel.textColor = .systemOrange
        } else {
            productStockLabel.text = "잔여수량 :  \(String(product.stock))"
        }
    }
    
    private func setTextAttribute(of target: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: target)
        attributedText.addAttributes(attributes, range: (target as NSString).range(of: target))
        
        return attributedText
    }
}

extension ListCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        productNameLabel.text = ""
        productPriceLabel.attributedText = nil
        productPriceLabel.textColor = .systemGray
        productPriceLabel.text = ""
        
        productStockLabel.textColor = .systemGray
        productStockLabel.text = ""
        productBargainPriceLabel.textColor = .systemGray
        productBargainPriceLabel.text = ""
        setUpLayoutConstraints()
    }
}


