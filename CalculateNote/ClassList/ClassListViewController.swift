//
//  CollectionViewController.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.01.2024.
//

import UIKit
import SnapKit

class ClassListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Coordinating {
    var coordinator: Coordinator?
    var collectionView: UICollectionView!
    let cellIdentifier = "CustomCell"
    private let squareViewControllerKey = "SquareViewControllerKey"
    private var addButton: UIButton!
    
    var squareDataArray: [SquareData] {
        get {
            return UserDataManager.shared.loadSquareData()
        }
        set {
            UserDataManager.shared.saveSquareData(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage()
        setupCollectionView()
        setAddButton()
        view.backgroundColor = Colors.darkThemeColor
        squareDataArray = UserDataManager.shared.loadSquareData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ClassListViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((view.bounds.height - 300) / 2)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(300)
        }
    }
    
    private func backgroundImage() {
        let backgroundImageView = UIImageView(image: UIImage(named: "page"))
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 0)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setAddButton() {
        let addButton = UIButton(type: .system)
        addButton.setTitle("Sınıf Ekle", for: .normal)
        addButton.tintColor = Colors.darkThemeColor
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return squareDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ClassListViewCell
        
        if indexPath.item < squareDataArray.count {
            cell.configure(with: squareDataArray[indexPath.item])
        } else {
            cell.titleLabel.text = ""
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ClassListViewCell else {
            return
        }
        
        if let indexPath = collectionView.indexPath(for: selectedCell) {
            let selectedSquareData = squareDataArray[indexPath.item]
            
            coordinator?.eventOccured(with: .goToClassroom(className: selectedSquareData.className))
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }
}


extension ClassListViewController {
    @objc func addButtonTapped() {
        showAddItemDialog()
    }
    
    func showAddItemDialog() {
        let alertController = UIAlertController(title: "Yeni Sınıf Ekle", message: "Lütfen sınıf adını girin", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Sınıf Adı"
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Sınıf Ekle", style: .default) { [weak self] _ in
            if let itemName = alertController.textFields?.first?.text, !itemName.isEmpty {
                var newArray = self?.squareDataArray ?? []
                let newItem = SquareData(className: itemName)
                newArray.append(newItem)
                
                self?.squareDataArray = newArray
                self?.collectionView.reloadData()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
