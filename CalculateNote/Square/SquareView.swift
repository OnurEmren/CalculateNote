//
//  SquareView.swift
//  CalculateNote
//
//  Created by Onur Emren on 25.12.2023.
//

import Foundation
import UIKit

class SquareView: UIView, Coordinating {
    var coordinator: Coordinator?
    var tapGesture: UITapGestureRecognizer!
    var delegate: SquareViewDelegate?
    var goToDetailDelegate: GoToDetail?
    var deleteButton: UIButton!
    var classNameLabel: UILabel = UILabel()
    var backgroundImage: UIImageView!
    var onTap: (() -> Void)?
    var onDelete: (() -> Void)?
    
    var data: SquareData? {
        didSet {
            if let data = data {
                print("Setting data for SquareView: \(data.className)")
                className = data.className
                classNameLabel.text = data.className
            } else {
                print("SquareView data is nil.")
            }
        }
    }

    
    static var savedClassNames: [String] {
        return UserDefaults.standard.stringArray(forKey: "SavedClassNames") ?? []
    }
    
    var className: String = "" {
        didSet {
            if !className.isEmpty {
                var classNames = SquareView.savedClassNames
                if !classNames.contains(className) {
                    classNames.append(className)
                    UserDefaults.standard.set(classNames, forKey: "SavedClassNames")
                }
                
                if let savedNames = UserDefaults.standard.stringArray(forKey: "SavedClassNames") {
                    classNameLabel.text = savedNames.joined(separator: ", ")
                } else {
                    print("Failed to save class names.")
                }
            } else {
                print("Class name cannot be empty.")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupUI()
        setupDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupUI()
        setupDeleteButton()
    }
    
    private func setupUI() {
        classNameLabel = UILabel()
        classNameLabel.textAlignment = .center
        classNameLabel.backgroundColor = Colors.darkThemeColor
        classNameLabel.textColor = Colors.lightThemeColor
        classNameLabel.layer.cornerRadius = Constants.cornerRadius
        classNameLabel.layer.masksToBounds = true
        classNameLabel.font = UIFont.systemFont(ofSize: Constants.labelFont, weight: .bold)
        classNameLabel.numberOfLines = 0
        classNameLabel.alpha = 1.0
        classNameLabel.sizeToFit()
        addSubview(classNameLabel)
        
        classNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.classNameLabelTrailing)
            make.height.equalTo(Constants.classNameLabelHeight)
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.borderWidth = 1.5
        layer.borderColor = Colors.darkThemeColor.cgColor
        layer.cornerRadius = Constants.cornerRadius
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
        data = SquareData(className: "")
    }
    
    private func setupDeleteButton() {
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Sil", for: .normal)
        deleteButton.tintColor = .red
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.deleteButtonTop)
            make.trailing.equalToSuperview().offset(Constants.deleteButtonTrailing)
            make.width.equalTo(Constants.deleteButtonWidth)
            make.height.equalTo(Constants.deleteButtonHeight)
        }
    }
    
    @objc
    private func deleteButtonTapped() {
        let alert = UIAlertController(title: "Emin misiniz?", message: "Bu sınıfı silmek istediğinizden emin misiniz?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { [weak self] _ in
            self?.deleteSquare()
        }
        
        let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if let viewController = self.squareViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteSquare() {
        var classNames = SquareView.savedClassNames
        if let index = classNames.firstIndex(of: className) {
            classNames.remove(at: index)
            UserDefaults.standard.set(classNames, forKey: "SavedClassNames")
        }
        
        self.removeFromSuperview()
        squareViewController?.collectionView.reloadData()
       
    }

    
    @objc
    private func handleTap() {
           onTap?()
           if let squareData = data {
               _ = SquareData(className: squareData.className)
               delegate?.squareTapped(self)
           }
       }
    
    func animateGrowth() {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    func animateShrink() {
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
}

extension UIView {
    var squareViewController: SquareViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = nextResponder as? SquareViewController {
                return viewController
            }
        }
        return nil
    }
}
