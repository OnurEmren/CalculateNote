//
//  Constants.swift
//  CalculateNote
//
//  Created by Onur Emren on 6.01.2024.
//

import Foundation

enum Constants {
    //NameTextField Constants
    static let nameTextFieldTop = 10
    static let nameTextfieldWidth = 250
    
    //gradeTextField Constants
    static let gradeTextFieldTop = 50
    static let gradeTextFieldLeft = 90
    
    //General TextFields Constants
    static let textFieldHeight = 40
    static let textFieldWidth = 70
    static let textFieldsLeft = 40
    static let textFieldsBorder = 1.5
    static let cornerRadius = 10.0
    
    //ResultLabel Constants
    static let resultLabelOffset = -5
    static let labelFont = 18.0
    
    //DeleteButton Constants
    static let deleteButtonWidth = 40
    static let deleteButtonHeight = 20
    static let deleteButtonTop = 20
    static let deleteButtonTrailing = -5
    
    //ClassName Constants
    static let classNameLabelHeight = 30
    static let classNameLabelTrailing = 20
    
    //StackView Constants
    static let stackViewSpacing = 20.0
    
    //SettingsView Strings
    static let titleText = "Nasıl Kullanılır?"
    static let descriptionText = """
        
        
        
        
        • Bu uygulama Türkçe ve Yabancı Dil öğretmenlerinin sınav notlarını kolayca hesaplamaları amacıyla geliştirilmiştir.
        
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
        
        • Ortalama butonu ile girdiğiniz öğrencilere ait sınıf ortalamasını hesaplayabilirsiniz.
        
        • Kullanıcı bildirimi açısından uygulama eksiklikleri için onuremren33@gmail.com adresine geri bildirimlerinizi gönderebilirsiniz.
        
        """
}
