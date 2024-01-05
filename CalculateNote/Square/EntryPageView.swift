//
//  EntryPageView.swift
//  CalculateNote
//
//  Created by Onur Emren on 25.12.2023.
//

import Foundation
import UIKit
import SnapKit

class EntryPageView: UIView, SquareViewDelegate {
 
    
    var scrollView: UIScrollView!
    var addButton: UIButton!
    var navigationController = UINavigationController()
    var parentViewController: UIViewController?

    override func layoutSubviews() {
        super.layoutSubviews()
        loadSavedPages()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemCyan
        setupAddButton()
        setupScrollView()
        loadSavedPages()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
   
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: 0, height: bounds.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        addSubview(scrollView)
        
    }
    
    private func setupAddButton() {
        addButton = UIButton(type: .system)
        addButton.setTitle("Ekle", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc 
    private func addButtonTapped() {
        
        let squareWidth: CGFloat = 300
        let squareSpacing: CGFloat = 20
        
        let newSquare = SquareView(frame: CGRect(x: CGFloat(scrollView.subviews.count) * (squareWidth + squareSpacing),
                                                 y: (scrollView.frame.height - squareWidth) / 2,
                                                 width: squareWidth,
                                                 height: squareWidth))
        newSquare.backgroundColor = .red // veya başka bir renk
        
        
        
        newSquare.delegate = self
        scrollView.addSubview(newSquare)
        scrollView.contentSize = CGSize(width: newSquare.frame.maxX + squareSpacing, height: scrollView.frame.height)
        
        let offsetX = scrollView.contentSize.width - scrollView.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
    
    func squareTapped(_ squareView: SquareView) {
        let alert = UIAlertController(title: "Sınıf İsmi", message: "Lütfen sınıf ismini girin", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Sınıf İsmi"
        }
        
        let addAction = UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            guard let className = alert.textFields?.first?.text else { return }
            self?.handleClassNameEntered(className, for: squareView)
            
            self?.homeViewControllerFunction()
            
        }
        
        let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { [weak self] _ in
            squareView.removeFromSuperview()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        parentViewController?.present(alert, animated: true) {
            // UIAlertController kapatma işlemleri burada yapılır
            // Örneğin: print("Alert kapatıldı.")
        }
    }
    
    private func homeViewControllerFunction() {
        let vc = HomeViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func deleteButtonTapped(_ squareView: SquareView) {
        squareView.removeFromSuperview()
    }
    
    private func handleClassNameEntered(_ className: String, for squareView: SquareView) {
        print("Girilen Sınıf İsmi: \(className)")
        squareView.className = className
        squareView.classNameLabel.text = className
        savePageInfo(for: squareView)
    }
    
    func loadSavedPages() {
        let classNames = SquareView.savedClassNames
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        for (index, className) in classNames.enumerated() {
            print("Sayfa \(index) - Sınıf İsmi: \(className)")
            
            let squareWidth: CGFloat = 300
            let squareSpacing: CGFloat = 20
            
            let newSquare = SquareView(frame: CGRect(x: CGFloat(scrollView.subviews.count) * (squareWidth + squareSpacing),
                                                     y: scrollView.safeAreaInsets.top + (scrollView.frame.height - squareWidth) / 2,
                                                     width: squareWidth,
                                                     height: squareWidth))
            newSquare.delegate = self
            newSquare.className = className
            newSquare.classNameLabel.text = className
            scrollView.addSubview(newSquare)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(classNames.count) * (300 + 20), height: scrollView.frame.height)
        print("Toplam Sayfa Sayısı: \(classNames.count)")
    }
    
    private func savePageInfo(for squareView: SquareView) {
        let key = "PageInfo_\(squareView.tag)"
        UserDefaults.standard.set(squareView.className, forKey: key)
        squareView.classNameLabel.text = squareView.className
    }
}
