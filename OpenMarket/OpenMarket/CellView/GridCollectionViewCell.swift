//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/13.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell, OpenMarketCellProtocol {
    
    var productNameLabel: UILabel = UILabel()
    var productImageView: UIImageView = UIImageView()
    var productPriceLabel: UILabel = UILabel()
    var productBargainPriceLabel: UILabel = UILabel()
    var productStockLabel: UILabel = UILabel()
    var mainStackView: UIStackView = UIStackView()
    var priceStackView: UIStackView = UIStackView()
    var informationStackView: UIStackView = UIStackView()
    
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
            font: .preferredFont(for: .title3, weight: .semibold),
            textColor: .black,
            alignment: .center
        )
        productImageView = createImageView(contentMode: .scaleAspectFit)
        productPriceLabel = createLabel(
            font: .preferredFont(forTextStyle: .body),
            textColor: .systemGray,
            alignment: .center
        )
        productBargainPriceLabel = createLabel(
            font: .preferredFont(forTextStyle: .body),
            textColor: .systemGray,
            alignment: .center
        )
        productStockLabel = createLabel(
            font: .preferredFont(forTextStyle: .body),
            textColor: .systemGray,
            alignment: .center
        )
        mainStackView = createStackView(
            axis: .vertical,
            alignment: .center,
            distribution: .fill,
            spacing: 5,
            margin: UIEdgeInsets(top: 10, left: 10, bottom: 5, right: 10)
        )
        priceStackView = createStackView(
            axis: .vertical,
            alignment: .center,
            distribution: .fillProportionally,
            spacing: 0
        )
        informationStackView = createStackView(
            axis: .vertical,
            alignment: .center,
            distribution: .fillEqually,
            spacing: 5
        )
    }
    
    func setUpSubViewStructure() {
        priceStackView.addArrangedSubview(productPriceLabel)
        priceStackView.addArrangedSubview(productBargainPriceLabel)
        
        informationStackView.addArrangedSubview(productNameLabel)
        informationStackView.addArrangedSubview(priceStackView)
        informationStackView.addArrangedSubview(productStockLabel)
        
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(informationStackView)
        
        contentView.addSubview(mainStackView)
    }
    
    func setUpLayoutConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.5)
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

extension GridCollectionViewCell {
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
