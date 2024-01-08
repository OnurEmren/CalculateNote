//
//  ChechBoxView.swift
//  CalculateNote
//
//  Created by Onur Emren on 7.01.2024.
//

import Foundation
import UIKit
import SnapKit

class CheckBoxView: UIView {
    var checkBox1: UIButton!
    var checkBox2: UIButton!
    var checkBox3: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckBoxes()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCheckBoxes()
    }

    private func setupCheckBoxes() {
        checkBox1 = createCheckBox(title: "Yazılı Sınav")
        checkBox2 = createCheckBox(title: "Dinleme Sınavı")
        checkBox3 = createCheckBox(title: "Konuşma Sınavı")

        let stackView = UIStackView(arrangedSubviews: [checkBox1, checkBox2, checkBox3])
        stackView.axis = .horizontal
        stackView.spacing = 16
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func createCheckBox(title: String) -> UIButton {
        let checkBox = UIButton(type: .system)
        checkBox.setTitle(title, for: .normal)
        checkBox.tintColor = .black
        checkBox.isSelected = false
        checkBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        return checkBox
    }

    @objc private func checkBoxTapped(_ sender: UIButton) {
        resetCheckBoxes()
        sender.isSelected = true
        onCheckBoxTapped?(sender)
    }

    private func resetCheckBoxes() {
        checkBox1.isSelected = false
        checkBox2.isSelected = false
        checkBox3.isSelected = false
    }

    var onCheckBoxTapped: ((UIButton) -> Void)?
}
