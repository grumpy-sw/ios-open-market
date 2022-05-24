//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/23.
//

import UIKit

final class RegisterViewController: UIViewController, UIImagePickerControllerDelegate {
    var imageNumber: Int = 1
    var currency: Currency = .KRW
    
    var productImageView: UIImageView = UIImageView()
    
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
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
         return stackView
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
    
    let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let priceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    
    let currencyField: UISegmentedControl = UISegmentedControl(items: Currency.allCases.map{ $0.rawValue } )
    let discountedPriceField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인가격"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    let stockField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.addPadding()
        return textField
    }()
    let descriptionField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품설명"
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.contentVerticalAlignment = .top
        textField.addPadding()
        return textField
    }()
    
    var images:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView
            .register(ImageRegisterCell.classForCoder(), forCellWithReuseIdentifier: "imageCell")
        self.navigationItem.title = "상품등록"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneToMain))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.hidesBackButton = true
        let backbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backToMain))
        backbutton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.preferredFont(for: .body, weight: .semibold)], for: .normal)
        self.navigationItem.leftBarButtonItem = backbutton
        
        // Sub View Structure
        priceStackView.addArrangedSubview(priceField)
        priceStackView.addArrangedSubview(currencyField)
        
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(nameField)
        mainStackView.addArrangedSubview(priceStackView)
        mainStackView.addArrangedSubview(discountedPriceField)
        mainStackView.addArrangedSubview(stockField)
        mainStackView.addArrangedSubview(descriptionField)
        
        self.view.addSubview(mainStackView)
        
        // Constraints
        mainStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        mainStackView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        priceStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 15).isActive = true
        nameField.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        nameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        nameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        stockField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        stockField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        discountedPriceField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        discountedPriceField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        descriptionField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        descriptionField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        priceStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        priceStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        priceField.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        discountedPriceField.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        stockField.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05).isActive = true
        currencyField.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25).isActive = true
        
        
        currencyField.addTarget(self, action: #selector(changeCurrency(_:)), for: .valueChanged)
        currencyField.selectedSegmentIndex = 0
        self.changeCurrency(currencyField)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
}

extension RegisterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNumber <= 5 ? imageNumber : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageRegisterCell else {
            return ImageRegisterCell()
        }
        cell.plusButton.addTarget(self, action: #selector(actionSheetAlert), for: .touchUpInside)
        return cell
    }
}

extension UITextField {
    func addPadding() {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = ViewMode.always
    }
}

extension RegisterViewController: UINavigationControllerDelegate, UIPickerViewDelegate {
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        vc.cameraFlashMode = .on
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentAlbum() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             dismiss(animated: true, completion: nil)
        }
    
    @objc func actionSheetAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            self?.presentCamera()
        }
        let album = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
            self?.presentAlbum()
        }
        
        alert.addAction(cancel)
        alert.addAction(camera)
        alert.addAction(album)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func backToMain(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneToMain(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
        // Post
        
        // delegate
    }
    
    @objc func changeCurrency(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        if mode == Currency.KRW.value {
            currency = Currency.KRW
        } else if mode == Currency.USD.value {
            currency = Currency.USD
        }
    }
}
