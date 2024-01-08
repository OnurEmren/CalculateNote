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
        scrollView.addSubview(descriptionLabel)
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: frame.size.width, height: 1000)
        descriptionLabel.sizeToFit()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(-50)
            make.width.equalToSuperview().inset(10)
            make.left.equalTo(10)
            make.height.equalTo(1000)
        }
        
        descriptionLabel.text = """
        • Her sınıfa 50 öğrenci ekleyebilirsiniz.
        
        • Her öğrencinin adı ve üç farklı sınav alanındaki notları (Yazılı, Dinleme, Konuşma) kaydedilebilir.
        
        • Yazılı sınav notu, öğrencinin genel notuna %50 oranında etki ederken, Dinleme ve Konuşma sınavları %25'er oranında etki eder.
        
        • Uygulama, her öğrencinin notlarını temel alarak genel bir not ortalaması hesaplar.
        
        • Not hesaplama formülü: Genel Not =
        (Yazılı Not * 0.5) + (Dinleme Not * 0.25) + (Konuşma Not * 0.25).
        
        • Kullanıcılar ekledikleri sınıfları ve bu sınıflara ait öğrencileri takip edebilir.
        
        • Her öğrencinin genel notu, sınıf içinde karşılaştırmalı bir şekilde görüntülenebilir. Girilen notlar ve eklenen sınıflar, uygulama tarafından Kaydet ve Hesapla butonu ile kaydedilir.
        
        • Hesapla ve kaydet butonuna basıldığında not veya öğrenci ismi girilmemiş alanlar koyu renk ile belirtilir.
        
        • Öğrenci listesi alanında not girerken sadece üç not alanından sadece birini girmek istiyorsanız kolay olması açısından girmek istediğiniz alanı seçebilirsiniz. Bu durumda sadece seçtiğiniz alan ve öğrenci isimleri aktif olacaktır. Diğer alanlar kullanıma kapatılır ancak öncesinde yazdığınız not Hesapla ve Kaydet butonuna basıldığında gene de kaydedilecektir.
        
        • Kullanıcı bildirimi açısından uygulama eksiklikleri için onuremren33@gmail.com adresine geri bildirimlerinizi gönderebilirsiniz.
        
        """
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textColor = Colors.lightThemeColor
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        scrollView.backgroundColor = Colors.darkThemeColor
    }
}
