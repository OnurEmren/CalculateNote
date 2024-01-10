//
//  SquareViewController.swift
//  CalculateNote
//
//  Created by Onur Emren on 4.01.2024.
//

import UIKit


class ClassesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, GoToStudentNotesPage, Coordinating {
    var coordinator: Coordinator?
    private let squareView = ClassesView()
    private var squareData: [SquareData] = []
    private var settingsButton = UIButton()
    var collectionView: UICollectionView!
    private var addButton: UIButton!
    private var selectedSquareIndex: Int?
    private var className: String?
    private let squareViewControllerKey = "SquareViewControllerKey"
    private var squareViewModel = ClassesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        loadSavedPages()
        squareView.coordinator = coordinator
        view.backgroundColor = Colors.darkThemeColor
    }
    
//MARK: - Private Methods
    
    private func setupView() {
        let backgroundImageView = UIImageView(image: UIImage(named: "page"))
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 0)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        //Settings Button
        let settingsButton = UIBarButtonItem(
            title: "Hakkında",
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped))
        navigationItem.rightBarButtonItem = settingsButton
        settingsButton.tintColor = Colors.darkThemeColor
        
        //Add Button
        addButton = UIButton(type: .system)
        addButton.setTitle("Ekle", for: .normal)
        addButton.tintColor = Colors.darkThemeColor
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
        }
    }

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
        collectionView.register(ClassesCollectionViewCell.self, forCellWithReuseIdentifier: ClassesCollectionViewCell.identifier)
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((view.bounds.height - 300) / 2)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(300)
        }
    }
    
    //Alert Dialog
    private func showAddSquareAlert() {
        let alert = UIAlertController(title: "Kare Ekleyin", message: "Lütfen bir sınıf ekleyin", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Ekle", style: .default) { [weak self] _ in
            self?.addButtonTapped()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //User create a class and write to the className label.
    private func handleClassNameEntered(_ className: String, for squareView: ClassesView) {
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
        let classNames = ClassesView.savedClassNames
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
            if let className = alert.textFields?.first?.text, !className.isEmpty {
                self?.addSquare(with: className)
                self?.collectionView.reloadData()
            } else {
                let errorAlert = UIAlertController(title: "Hata", message: "Lütfen bir sınıf adı girin", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                errorAlert.addAction(okAction)
                self?.present(errorAlert, animated: true, completion: nil)
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
    private func settingsButtonTapped() {
        coordinator?.eventOccured(with: .goToSettings)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassesCollectionViewCell.identifier, for: indexPath) as! ClassesCollectionViewCell
        cell.goToDetailDelegate = self
        cell.squareData = squareData[indexPath.item]
        return cell
    }
    
//MARK: - Delegate Method
    
    func squareTappedForCell(_ cell: ClassesCollectionViewCell, with className: String) {
        if let indexPath = collectionView.indexPath(for: cell) {
            selectedSquareIndex = indexPath.item
            squareData[selectedSquareIndex!].className = className
            let selectedSquareData = squareData[selectedSquareIndex!]
            coordinator?.eventOccured(with: .goToClassroom(className: selectedSquareData.className))
        }
    }
}

