//
//  StudentsView.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.11.2023.
//

import Foundation
import SnapKit
import UIKit

class StudentsView: UITableViewCell {
    
    var nameLabel: UILabel!
    var resultLabel: UILabel!
    var gradeTextField1: UITextField!
    var gradeTextField2: UITextField!
    var gradeTextField3: UITextField!
    var gradeTextFields: [UITextField] = []
    var student: Students!
    
    var displayButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        
        gradeTextField1 = UITextField()
        gradeTextField1.borderStyle = .roundedRect
        contentView.addSubview(gradeTextField1)
        
        gradeTextField2 = UITextField()
        gradeTextField2.borderStyle = .roundedRect
        contentView.addSubview(gradeTextField2)
        
        gradeTextField3 = UITextField()
        gradeTextField3.borderStyle = .roundedRect
        contentView.addSubview(gradeTextField3)
        
        gradeTextFields = [gradeTextField1, gradeTextField2, gradeTextField3] // gradeTextFields dizisi oluşturuldu

        for (index, gradeTextField) in gradeTextFields.enumerated() {
            gradeTextField.tag = index
            gradeTextField.addTarget(self, action: #selector(gradeTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        resultLabel = UILabel()
             resultLabel.textAlignment = .center
             resultLabel.textColor = .black
             resultLabel.font = UIFont.systemFont(ofSize: 16)
             contentView.addSubview(resultLabel)

             resultLabel.snp.makeConstraints { (make) in
                 make.centerX.equalToSuperview()
                 make.bottom.equalToSuperview().offset(-5)
             }
    }
    
    func updateResultLabel(withAverage average: Double) {
            resultLabel.text = "Ortalama: \(average)"
        }
    
    @objc func gradeTextFieldDidChange(_ textField: UITextField) {
        print("Grade text field changed: \(textField.text ?? "nil")")
        if let text = textField.text, let grade = Double(text) {
            let index = textField.tag
            student?.grades[index] = grade
        }
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        gradeTextField1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        gradeTextField2.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(90)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        gradeTextField3.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(160)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
    }
}
