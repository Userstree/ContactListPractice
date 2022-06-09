//
// Created by Dossymkhan Zhulamanov on 01.06.2022.
//

import UIKit

protocol EditContactDelegate: AnyObject {
    func editWith(fullName: String, phoneNumber: String, indexInTable: Int)
}

class EditOrAddContactViewController: UIViewController {

    private var fullName: String = ""
    private var phoneNumber: String = ""
    private var indexInTable: Int = 0

    private var setGender: String = "male.jpeg" {
        didSet {
            setGender += ".jpeg"
        }
    }

    var contactsViewModel: ContactsViewModel

    init (viewModel: ContactsViewModel, indexInTable: Int? = nil) {
        contactsViewModel = viewModel
        if let index = indexInTable {
            fullName = viewModel.contacts[index].firstName + " " + viewModel.contacts[index].lastName
            phoneNumber = viewModel.contacts[index].telephone
            self.indexInTable = index
        }
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(viewModelAndDefault: ContactsViewModel) {
        self.init(viewModel: viewModelAndDefault, indexInTable: 0)
        fullName = "Enter Name"
        phoneNumber = "Enter phone number"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        nameField.placeholder = fullName
        phoneNumberField.placeholder = phoneNumber
        configureAddButton()
    }

    private func configureAddButton () {
        let add = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = add
    }

    @objc func cancelButtonTapped() {
        if isModal {
            dismiss(animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }

    @objc private func saveButtonTapped() {
        if isModal {
            let nameToPass = (nameField.text == "") ? fullName : nameField.text
            let phoneNumberToPass = (phoneNumberField.text == "") ? phoneNumber : phoneNumberField.text
            contactsViewModel.editContact(at: indexInTable, name: nameToPass ?? "", phoneNumber: phoneNumberToPass ?? "")
            dismiss(animated: true)
        } else {
            guard let name = nameField.text, let number = phoneNumberField.text else { return }
            contactsViewModel.addContact(contact: Contact(firstName: name, lastName: "", telephone: number))
            navigationController?.popToRootViewController(animated: true)
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
        gendersList.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        gendersList[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gender = gendersList[row]
        self.setGender = gender
    }
}
