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
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textColor = Colors.lightThemeColor
        titleLabel.backgroundColor = Colors.darkThemeColor
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        contentView.addSubview(titleLabel)
        
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Sil", for: .normal)
        deleteButton.tintColor = .red
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
