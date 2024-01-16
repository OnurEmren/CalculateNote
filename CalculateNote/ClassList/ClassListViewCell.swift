//
//  CustomCollectionView.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.01.2024.
//

import Foundation
import UIKit
import SnapKit

class ClassListViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var deleteButton: UIButton!
    var className: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1.5
        layer.cornerRadius = Constants.cornerRadius
        layer.borderColor = Colors.darkThemeColor.cgColor
        layer.masksToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textColor = Colors.lightThemeColor
        titleLabel.backgroundColor = Colors.darkThemeColor
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = Constants.cornerRadius
        titleLabel.layer.masksToBounds = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.labelFont)
        contentView.addSubview(titleLabel)
        
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Sil", for: .normal)
        deleteButton.tintColor = .red
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: Constants.labelFont - 2)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        contentView.addSubview(deleteButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.leading.equalTo(40)
            
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.deleteButtonTop)
            make.trailing.equalToSuperview().offset(Constants.deleteButtonTrailing)
            make.width.equalTo(Constants.deleteButtonWidth)
            make.height.equalTo(Constants.deleteButtonHeight)
        }
    }
    
    func configure(with data: SquareData) {
        titleLabel.text = data.className
    }
    
    @objc func deleteButtonTapped() {
        guard let collectionView = superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else {
            return
        }
        
        let alertController = UIAlertController(
            title: "Sınıfı sil?",
            message: "Bu öğeyi sildiğiniz zaman sınıfla ilgili kaydettiğiniz tüm veriler silinecektir.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            UserDataManager.shared.removeSquareData(at: indexPath.item)
            collectionView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        if let viewController = collectionView.delegate as? UIViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    override var canBecomeFocused: Bool {
          return true
      }

      override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
          if isFocused {
              // Hücre odaklandığında yapılacak işlemler
              self.backgroundColor = UIColor.yellow
          } else {
              // Hücre odaktan çıkınca yapılacak işlemler
              self.backgroundColor = UIColor.white
          }
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
