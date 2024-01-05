//
//  SquareViewController.swift
//  CalculateNote
//
//  Created by Onur Emren on 4.01.2024.
//

import UIKit


class SquareViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GoToDetail {
    private let squareView = SquareView()
    private var collectionView: UICollectionView!
    private var addButton: UIButton!
    private var squareData: [SquareData] = []
    private var selectedSquareIndex: Int?
    private var className: String?
    private let squareViewControllerKey = "SquareViewControllerKey"
    private var squareViewModel = SquareViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupAddButton()
        loadSavedPages()
        view.backgroundColor = Colors.darkThemeColor
        
        // User must create a square
        if squareData.isEmpty || squareData.allSatisfy({ $0.className.isEmpty }) {
            showAddSquareAlert()
        }
    }
    
//MARK: - Private Methods
    
    //Setup Views
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.itemSize = CGSize(width: 300, height: 300)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isUserInteractionEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SquareCollectionViewCell.self, forCellWithReuseIdentifier: SquareCollectionViewCell.identifier)
        view.addSubview(collectionView)
        
        // SnapKit kullanarak constraints ayarlamak
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((view.bounds.height - 300) / 2)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(300)
        }
    }
    
    private func setupAddButton() {
        addButton = UIButton(type: .system)
        addButton.setTitle("Ekle", for: .normal)
        addButton.tintColor = .white
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    //Alert Dialog
    private func showAddSquareAlert() {
        let alert = UIAlertController(title: "Kare Ekleyin", message: "Lütfen bir kare ekleyin", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Ekle", style: .default) { [weak self] _ in
            self?.addButtonTapped()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //User create a class and write to the square's label.
    private func handleClassNameEntered(_ className: String, for squareView: SquareView) {
        if let index = squareData.firstIndex(where: { $0.className == squareView.className }) {
            squareData[index].className = className
            collectionView.reloadData()
            saveSquareData(withKey: squareViewControllerKey)
        }
    }
    
//MARK: - Save and Load Business
    
    private func saveSquareData(withKey key: String) {
        squareViewModel.saveData(withKey: key)
    }
    
    private func loadSavedPages() {
        let classNames = SquareView.savedClassNames
        squareData = classNames.map { SquareData(className: $0) }
        collectionView.reloadData()
        
        if squareData.isEmpty || squareData.allSatisfy({ $0.className.isEmpty }) {
            showAddSquareAlert()
        }
    }
    
//MARK: - @objc Methods
    
    @objc
    private func addButtonTapped() {
        let alert = UIAlertController(title: "Sınıf İsmi", message: "Lütfen sınıf ismini girin", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Sınıf İsmi"
        }
        
        let addAction = UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            if let className = alert.textFields?.first?.text {
                self?.addSquare(with: className)
                self?.collectionView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        saveSquareData(withKey: squareViewControllerKey)
        self.collectionView.reloadData()
    }
    
    @objc
    private func addSquare(with className: String){
        let newSquareData = SquareData(className: className)
        squareData.append(newSquareData)
        collectionView.reloadData()
        saveSquareData(withKey: squareViewControllerKey)
    }
    
// MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return squareData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquareCollectionViewCell.identifier, for: indexPath) as! SquareCollectionViewCell
        cell.goToDetailDelegate = self
        cell.squareData = squareData[indexPath.item]
        return cell
    }
    
//MARK: - Delegate Method
    
    func squareTappedForCell(_ cell: SquareCollectionViewCell, with className: String) {
        if let indexPath = collectionView.indexPath(for: cell) {
            selectedSquareIndex = indexPath.item
            squareData[selectedSquareIndex!].className = className
            let selectedSquareData = squareData[selectedSquareIndex!]
            let homeViewController = HomeViewController(squareData: selectedSquareData, className: selectedSquareData.className)
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}

