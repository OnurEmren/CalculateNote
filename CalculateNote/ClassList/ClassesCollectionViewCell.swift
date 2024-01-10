//
//  SquareCollectionViewCell.swift
//  CalculateNote
//
//  Created by Onur Emren on 4.01.2024.
//

import Foundation
import UIKit

protocol ClassesViewDelegate: AnyObject {
    func squareTapped(_ squareView: ClassesView)
    func deleteButtonTapped(_ squareView: ClassesView)
}

protocol GoToStudentNotesPage: AnyObject {
    func squareTappedForCell(_ cell: ClassesCollectionViewCell, with className: String)
}

class ClassesCollectionViewCell: UICollectionViewCell {
    static let identifier = "SquareCollectionViewCell"
    var className: String = ""
    var squareView: ClassesView!
    weak var delegate: ClassesViewDelegate?
    weak var goToDetailDelegate: GoToStudentNotesPage?
    
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
        squareView = ClassesView(frame: bounds)
        squareView.delegate = delegate
        squareView.goToDetailDelegate = goToDetailDelegate
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
