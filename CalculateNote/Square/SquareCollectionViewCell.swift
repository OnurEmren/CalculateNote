//
//  SquareCollectionViewCell.swift
//  CalculateNote
//
//  Created by Onur Emren on 4.01.2024.
//

import Foundation
import UIKit

protocol SquareViewDelegate: AnyObject {
    func squareTapped(_ squareView: SquareView)
    func deleteButtonTapped(_ squareView: SquareView)
}

protocol GoToDetail: AnyObject {
    func squareTappedForCell(_ cell: SquareCollectionViewCell, with className: String)
}

class SquareCollectionViewCell: UICollectionViewCell {
    static let identifier = "SquareCollectionViewCell"
    var className: String = ""
    var squareView: SquareView!
    weak var delegate: SquareViewDelegate?
    weak var goToDetailDelegate: GoToDetail?
    
    var squareData: SquareData? {
        didSet {
            squareView.data = squareData
            squareView.className = squareData?.className ?? ""
            squareView.classNameLabel.text = squareData?.className ?? ""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSquareView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSquareView()
    }
    
    
    private func setupSquareView() {
        squareView = SquareView(frame: bounds)
        squareView.delegate = delegate
        squareView.isUserInteractionEnabled = true
        addSubview(squareView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(squareTapped))
        squareView.addGestureRecognizer(tapGesture)
        squareView.frame = bounds
    }
    
    private func handleClassNameEntered(_ className: String) {
        squareData?.className = className
        squareView.classNameLabel.text = className
    }
    
    @objc
    private func squareTapped() {
        goToDetailDelegate?.squareTappedForCell(self, with: squareView.className)
    }
}

extension UIView {
    var viewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
