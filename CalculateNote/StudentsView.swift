//
//  StudentsView.swift
//  CalculateNote
//
//  Created by Onur Emren on 14.11.2023.
//

import Foundation
import SnapKit
import UIKit

class StudentsView: UITableViewCell, UITextFieldDelegate {
    
    var nameTextField: UITextField!
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
        updateResultLabel(withAverage: 0.0)
        
        nameTextField.delegate = self
        gradeTextField1.delegate = self
        gradeTextField2.delegate = self
        gradeTextField3.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        nameTextField = UITextField()
        nameTextField.borderStyle = .roundedRect
        nameTextField.placeholder = "Öğrenci Adı"
        contentView.addSubview(nameTextField)
        
        gradeTextField1 = UITextField()
        gradeTextField1.borderStyle = .roundedRect
        gradeTextField1.placeholder = "Not1"
        gradeTextField1.keyboardType = .numberPad
        contentView.addSubview(gradeTextField1)
        
        gradeTextField2 = UITextField()
        gradeTextField2.borderStyle = .roundedRect
        gradeTextField2.keyboardType = .numberPad
        contentView.addSubview(gradeTextField2)
        
        gradeTextField3 = UITextField()
        gradeTextField3.borderStyle = .roundedRect
        gradeTextField3.keyboardType = .numberPad
        contentView.addSubview(gradeTextField3)
        
        gradeTextFields = [gradeTextField1, gradeTextField2, gradeTextField3]
        
        for (index, gradeTextField) in gradeTextFields.enumerated() {
            gradeTextField.tag = index
            gradeTextField.addTarget(self, action: #selector(gradeTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        resultLabel = UILabel()
        resultLabel.textAlignment = .center
        resultLabel.textColor = .white
        resultLabel.font = .boldSystemFont(ofSize: 18)
        contentView.addSubview(resultLabel)
        
        resultLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let indexPath = getIndexPath(for: textField), let text = textField.text {
            // Öğrencinin adını ya da notlarını güncelle
            switch textField {
            case nameTextField:
                student?.name = text
            case gradeTextField1:
                student?.grades[0] = Double(text) ?? 0
            case gradeTextField2:
                student?.grades[1] = Double(text) ?? 0.0
            case gradeTextField3:
                student?.grades[2] = Double(text) ?? 0.0
            default:
                break
            }
        }
    }
    
    func updateResultLabel(withAverage average: Double) {
        resultLabel.text = "Ortalama: \(String(format: "%.2f", average))"
        resultLabel.isHidden = false
    }
    
    
    @objc func gradeTextFieldDidChange(_ textField: UITextField) {
        print("Grade text field changed: \(textField.text ?? "nil")")
        if let text = textField.text, let grade = Double(text) {
            let index = textField.tag
            student?.grades[index] = grade
        }
    }
    
    func setupConstraints() {
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        gradeTextField1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        gradeTextField2.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(90)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        gradeTextField3.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(160)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
    }
    
    func updateUI(with student: Students) {
        nameTextField.text = student.name
        gradeTextField1.text = "\(student.grades[0])"
        gradeTextField2.text = "\(student.grades[1])"
        gradeTextField3.text = "\(student.grades[2])"
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
           // TextField içine tıklandığında varsayılan değeri temizle
           textField.text = ""
       }
}

extension UITableViewCell {
    func getIndexPath(for textField: UITextField) -> IndexPath? {
        if let tableView = superview as? UITableView {
            let point = convert(bounds.origin, to: tableView)
            return tableView.indexPathForRow(at: point)
        }
        return nil
    }
}

