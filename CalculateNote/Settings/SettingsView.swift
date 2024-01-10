//
//  SettingsView.swift
//  CalculateNote
//
//  Created by Onur Emren on 8.01.2024.
//

import Foundation
import UIKit
import SnapKit

class SettingsView: UIView, UIScrollViewDelegate {
    private var scrollView: UIScrollView = UIScrollView()
    private var descriptionLabel: UILabel = UILabel()
    private var titleLabel: UILabel = UILabel()
    private var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSettingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSettingsView() {
        addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: frame.size.width, height: 1200)
        descriptionLabel.sizeToFit()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.text = Constants.titleText
        titleLabel.textColor = Colors.lightThemeColor
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top).offset(-50)
            make.width.equalToSuperview().inset(10)
            make.left.equalTo(10)
            make.height.equalTo(1200)
        }
        
        descriptionLabel.text = Constants.descriptionText
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textColor = Colors.lightThemeColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        scrollView.backgroundColor = Colors.darkThemeColor
    }
}
