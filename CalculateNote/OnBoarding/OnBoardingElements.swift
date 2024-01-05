//
//  OnBoardingElements.swift
//  CalculateNote
//
//  Created by Onur Emren on 4.01.2024.
//

import UIKit
import SnapKit
import Lottie

class OnBoardingElements {
        
    func addImageView(_ image: UIImageView, withTitle title: UILabel, andSubtitle subtitle: UILabel, to view: UIView) {
        view.addSubview(image)
        view.addSubview(title)
        view.addSubview(subtitle)
        
        
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        title.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(45)
        }

        subtitle.snp.makeConstraints { make in
            make.top.equalTo(title.snp.top).offset(30)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
}
