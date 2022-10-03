//
//  ProductView.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/24.
//

import UIKit

private extension OpenMarketConstant {
    static let productPrice = "상품가격"
    static let discountedPrice = "할인가격"
    static let productStock = "재고수량"
}

final class ProductView: UIView {
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return stackView
    }()
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return scrollView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OpenMarketConstant.productName
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let priceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OpenMarketConstant.productPrice
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.keyboardType = .numberPad
        textField.addPadding()
        return textField
    }()
    
    let currencyField: UISegmentedControl = UISegmentedControl(items: Currency.allCases.map{ $0.rawValue } )
    let discountedPriceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OpenMarketConstant.discountedPrice
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.keyboardType = .numberPad
        textField.addPadding()
        return textField
    }()
    
    let stockField: UITextField = {
        let textField = UITextField()
        textField.placeholder = OpenMarketConstant.productStock
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.keyboardType = .numberPad
        textField.addPadding()
        return textField
    }()
    
    let descriptionView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 5, bottom: 15, right: 5)
        return textView
    }()
    
    var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        registerCollectionViewCell()
        setUpSubViewStructure()
        setUpLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCollectionViewCell() {
        collectionView
            .register(ImageRegisterCell.classForCoder(), forCellWithReuseIdentifier: "imageCell")
    }
    
    private func setUpSubViewStructure() {
        priceStackView.addArrangedSubview(priceField)
        priceStackView.addArrangedSubview(currencyField)
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(nameField)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(discountedPriceField)
        mainStackView.addArrangedSubview(stockField)
        mainStackView.addArrangedSubview(descriptionView)
        
        mainScrollView.addSubview(mainStackView)
        self.addSubview(mainScrollView)
    }
    
    private func setUpLayoutConstraints() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priceStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.20),
            collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            nameField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05),
            nameField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            stockField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stockField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stockField.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05)
        ])
        
        NSLayoutConstraint.activate([
            discountedPriceField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            discountedPriceField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            discountedPriceField.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05)
        ])

        NSLayoutConstraint.activate([
            descriptionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            descriptionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.466)
        ])
        
        NSLayoutConstraint.activate([
            priceStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            priceStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
            
        ])
        
        NSLayoutConstraint.activate([
            priceStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            priceStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
            
        ])
        
        NSLayoutConstraint.activate([
            priceField.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05)
        ])
        
        NSLayoutConstraint.activate([
            currencyField.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25)
        ])
    }
    
    func validTextField(_ textField: UITextField) -> Bool {
        let currentText = textField.text ?? ""
        return currentText.count <= 100 && currentText.count >= 3
    }
    
    func validTextView(_ textView: UITextView) -> Bool {
        let currentText = textView.text ?? ""
        return currentText.count <= 1000 && currentText.count >= 10
    }
}

extension UITextField {
    func addPadding() {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = ViewMode.always
    }
}
