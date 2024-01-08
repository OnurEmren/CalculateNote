//
//  HomeTableViewCell.swift
//  CalculateNote
//
//  Created by Onur Emren on 2.01.2024.
//

import Foundation
import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell, UITextFieldDelegate {
    var nameTextField: UITextField!
    var resultLabel: UILabel!
    var gradeTextField1: UITextField!
    var gradeTextField2: UITextField!
    var gradeTextField3: UITextField!
    var gradeTextFields: [UITextField] = []
    var studentList: [StudentAndNotesModel] = []
    var squareData: SquareData?
    var student: StudentAndNotesModel!
    var isChecked = false
    
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        nameTextField = UITextField()
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderWidth = Constants.textFieldsBorder
        nameTextField.layer.cornerRadius = Constants.cornerRadius
        nameTextField.layer.masksToBounds = true
        nameTextField.font = UIFont.systemFont(ofSize: Constants.labelFont)
        nameTextField.placeholder = "Öğrenci Adı"
        nameTextField.textColor = Colors.cellsColor
        nameTextField.backgroundColor = Colors.lightThemeColor
        contentView.addSubview(nameTextField)
        
        gradeTextField1 = UITextField()
        gradeTextField1.borderStyle = .roundedRect
        gradeTextField1.placeholder = "Not 1"
        gradeTextField1.keyboardType = .numberPad
        gradeTextField1.textColor = Colors.darkThemeColor
        gradeTextField1.layer.borderWidth = Constants.textFieldsBorder
        gradeTextField1.layer.cornerRadius = Constants.cornerRadius
        gradeTextField1.layer.masksToBounds = true
        contentView.addSubview(gradeTextField1)
        
        gradeTextField2 = UITextField()
        gradeTextField2.borderStyle = .roundedRect
        gradeTextField2.keyboardType = .numberPad
        gradeTextField2.placeholder = "Not 2"
        gradeTextField2.textColor = Colors.darkThemeColor
        gradeTextField2.layer.borderWidth = Constants.textFieldsBorder
        gradeTextField2.layer.cornerRadius = Constants.cornerRadius
        gradeTextField2.layer.masksToBounds = true
        contentView.addSubview(gradeTextField2)
        
        gradeTextField3 = UITextField()
        gradeTextField3.borderStyle = .roundedRect
        gradeTextField3.keyboardType = .numberPad
        gradeTextField3.placeholder = "Not 3"
        gradeTextField3.textColor = Colors.darkThemeColor
        gradeTextField3.layer.borderWidth = Constants.textFieldsBorder
        gradeTextField3.layer.cornerRadius = Constants.cornerRadius
        gradeTextField3.layer.masksToBounds = true
        contentView.addSubview(gradeTextField3)
        
        gradeTextFields = [gradeTextField1, gradeTextField2, gradeTextField3]
        
        for (index, gradeTextField) in gradeTextFields.enumerated() {
            gradeTextField.tag = index
            gradeTextField.addTarget(self, action: #selector(gradeTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        resultLabel = UILabel()
        resultLabel.textAlignment = .center
        resultLabel.textColor = .white
        resultLabel.font = .boldSystemFont(ofSize: Constants.labelFont)
        contentView.addSubview(resultLabel)
        
        resultLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(Constants.resultLabelOffset)
        }
    }
    
    func setupConstraints() {
        nameTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.nameTextFieldTop)
            make.left.equalToSuperview().offset(Constants.textFieldsLeft)
            make.width.equalTo(Constants.nameTextfieldWidth)
        }
        
        gradeTextField1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.gradeTextFieldTop)
            make.left.equalToSuperview().offset(Constants.textFieldsLeft)
            make.width.equalTo(Constants.textFieldWidth)
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        gradeTextField2.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.gradeTextFieldTop)
            make.left.equalTo(gradeTextField1.snp.left).offset(Constants.gradeTextFieldLeft)
            make.width.equalTo(Constants.textFieldWidth)
            make.height.equalTo(Constants.textFieldHeight)
        }
        
        gradeTextField3.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Constants.gradeTextFieldTop)
            make.left.equalTo(gradeTextField2.snp.left).offset(Constants.gradeTextFieldLeft)
            make.width.equalTo(Constants.textFieldWidth)
            make.height.equalTo(Constants.textFieldHeight)
        }
    }
    
    func updateUI(with student: StudentAndNotesModel) {
        nameTextField.text = student.name
        gradeTextField1.text = "\(student.grades[0])"
        gradeTextField2.text = "\(student.grades[1])"
        gradeTextField3.text = "\(student.grades[2])"
    }
    
    func updateResultLabel(withAverage average: Double) {
        resultLabel.text = "Ortalama: \(String(format: "%.2f", average))"
        resultLabel.textColor = average < 50.0 ? .red : Colors.darkThemeColor
        resultLabel.isHidden = false
    }
    
    func updateGradeTextFieldColors(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            textField.backgroundColor = Colors.lightThemeColor
            textField.textColor = Colors.darkThemeColor
        } else {
            textField.backgroundColor = Colors.darkThemeColor
            textField.textColor = Colors.lightThemeColor
            if !textField.isEditing {
                textField.textColor = .white
                textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _ = getIndexPath(for: textField), let text = textField.text {
            switch textField {
            case nameTextField:
                student?.name = text
                updateGradeTextFieldColors(textField)
            case gradeTextField1, gradeTextField2, gradeTextField3:
                if let grade = Double(text) {
                    let index = textField.tag
                    student?.grades[index] = grade
                }
                updateGradeTextFieldColors(textField)
            default:
                break
            }
        }
    }
    
    func enableTextFields(for checkBoxTitle: String) {
        isChecked = !isChecked
        switch checkBoxTitle {
        case "Yazılı Sınav":
            gradeTextField1.isEnabled = true
            gradeTextField2.isEnabled = false
            gradeTextField3.isEnabled = false
        case "Dinleme Sınavı":
            gradeTextField1.isEnabled = false
            gradeTextField2.isEnabled = true
            gradeTextField3.isEnabled = false
        case "Konuşma Sınavı":
            gradeTextField1.isEnabled = false
            gradeTextField2.isEnabled = false
            gradeTextField3.isEnabled = true
        default:
            gradeTextField1.isEnabled = true
            gradeTextField2.isEnabled = true
            gradeTextField3.isEnabled = true
        }
        
        upgradeCheckBoxColors(gradeTextField1)
        upgradeCheckBoxColors(gradeTextField2)
        upgradeCheckBoxColors(gradeTextField3)
    }

    func upgradeCheckBoxColors(_ textField: UITextField) {
        if textField.isEnabled {
            textField.backgroundColor = .white // Etkinse beyaz renk
            textField.textColor = .black
        } else {
            textField.backgroundColor = .lightGray // Devre dışı bırakılmışsa gri renk
            textField.textColor = .darkGray
        }
    }

    
    @objc func gradeTextFieldDidChange(_ textField: UITextField) {
        print("Grade text field changed: \(textField.text ?? "nil")")
        if let text = textField.text, let grade = Double(text) {
            let index = textField.tag
            student?.grades[index] = grade
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
