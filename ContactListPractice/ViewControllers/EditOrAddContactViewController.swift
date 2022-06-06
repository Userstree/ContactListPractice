//
// Created by Dossymkhan Zhulamanov on 01.06.2022.
//

import UIKit

protocol EditContactDelegate: AnyObject {
    func editedWith(name: String, phoneNumber: String, gender: String)
}

protocol SaveContactDelegate: AnyObject {
    func saveWith(name: String, phoneNumber: String)
}

class EditOrAddContactViewController: UIViewController {

    private var name: String = ""
    private var phoneNumber: String = ""
    private var setGender: String = ""

    weak var editDelegate: EditContactDelegate?

    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(name: "Name", phoneNumber: "Phone Number")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private let gendersList = ["male", "female"]

    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.setLeftPaddingPoints(5)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocorrectionType = .no
        field.layer.borderColor = UIColor.blue.cgColor
        field.layer.borderWidth = 1
        return field
    }()

    private lazy var phoneNumberField: UITextField = {
        let field = UITextField()
        field.setLeftPaddingPoints(5)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocorrectionType = .no
        field.layer.borderColor = UIColor.blue.cgColor
        field.layer.borderWidth = 1
        return field
    }()

    private lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var upperVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var mainVStack: UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 10)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
    }()

    override func loadView() {
        super.loadView()
        setStyle()
        configureViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.placeholder = name
        self.phoneNumberField.placeholder = phoneNumber
        configureAddButton()
    }

    private func configureAddButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = add
    }

    @objc func cancelButtonTapped() {
        print("dissmiss")
        if self.isModal {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    @objc private func saveButtonTapped() {
        print("hi")
        if self.isModal {
            editDelegate?.editedWith(name: nameField.text ?? "", phoneNumber: phoneNumberField.text ?? "", gender: setGender)
            self.dismiss(animated: true)
        } else {

        }
    }

    private func setStyle() {
        title = "New Contact"
        view.backgroundColor = .white
    }

    private func configureViews() {
        [nameField, phoneNumberField, genderPicker].forEach(upperVStack.addArrangedSubview)
        [upperVStack, saveButton].forEach(mainVStack.addArrangedSubview)
        view.addSubview(mainVStack)
        makeConstraints()
    }

    private func makeConstraints() {

        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            nameField.heightAnchor.constraint(equalToConstant: 45),
            phoneNumberField.heightAnchor.constraint(equalToConstant: 45),

            upperVStack.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
    }

}

extension EditOrAddContactViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gendersList[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gender = gendersList[row]
        self.setGender = gender + ".jpeg"
    }
}