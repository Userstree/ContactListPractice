//
// Created by Dossymkhan Zhulamanov on 01.06.2022.
//

import UIKit

class AddContactVIewController: UIViewController {

    private let gendersList = ["male", "female"]

    private lazy var nameField:                 UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Name"
        field.autocorrectionType = .no
        field.layer.borderColor = UIColor.blue.cgColor
        field.layer.borderWidth = 1
        return field
    }()

    private lazy var phoneNumberField:          UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "phoneNumber"
        field.autocorrectionType = .no
        field.layer.borderColor = UIColor.blue.cgColor
        field.layer.borderWidth = 1
        return field
    }()

    private lazy var genderPicker:              UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private lazy var saveButton:                UIButton = {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var upperVerticalStack:        UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var mainVerticalStack:         UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
    }()

    @objc private func saveButtonTapped() {
        print("hi")
    }

    override func loadView() {
        super.loadView()
        setStyle()
        configureViews()
    }

    private func setStyle() {
        title = "New Contact"
        view.backgroundColor = .white
    }

    private func configureViews() {
        [nameField, phoneNumberField, genderPicker].forEach (upperVerticalStack.addArrangedSubview)
        [upperVerticalStack, saveButton].forEach(mainVerticalStack.addArrangedSubview)
        view.addSubview(mainVerticalStack)
        makeConstraints()
    }

    private func makeConstraints() {

        NSLayoutConstraint.activate([
            mainVerticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainVerticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainVerticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainVerticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 45),

            nameField.heightAnchor.constraint(equalToConstant: 45),
            phoneNumberField.heightAnchor.constraint(equalToConstant: 45),

            upperVerticalStack.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
    }
}

extension AddContactVIewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gendersList[row]
    }
}
