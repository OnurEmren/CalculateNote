//
//  SquareView.swift
//  CalculateNote
//
//  Created by Onur Emren on 25.12.2023.
//

import Foundation
import UIKit

protocol ReloadSquareData: AnyObject {
    func reloadData()
}

class SquareView: UIView {
    
    var tapGesture: UITapGestureRecognizer!
    var delegate: SquareViewDelegate?
    var deleteButton: UIButton!
    var onTap: (() -> Void)?
    var studentCount: Int = 0
    var reloadCollectionViewDelegate: ReloadSquareData?
    
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

    var classNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
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
        classNameLabel.layer.cornerRadius = 10
        classNameLabel.layer.masksToBounds = true
        classNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        classNameLabel.numberOfLines = 0
        classNameLabel.alpha = 1.0
        classNameLabel.sizeToFit()
        
        addSubview(classNameLabel)
        classNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
    }
    
    private func setupView() {
        backgroundColor = Colors.appMainColor
        layer.cornerRadius = 10
        
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
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
    }
    
    @objc
    private func deleteButtonTapped() {
        removeFromSuperview()
        var classNames = SquareView.savedClassNames
        if let index = classNames.firstIndex(of: className) {
            classNames.remove(at: index)
            UserDefaults.standard.set(classNames, forKey: "SavedClassNames")
        }
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
