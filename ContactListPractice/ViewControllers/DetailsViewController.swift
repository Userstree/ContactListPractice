//
// Created by Dossymkhan Zhulamanov on 02.06.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    private var fullName: String = ""
    private var phoneNumber: String = ""
    private var indexInTable: Int = 0

    private var contactsViewModel: ContactsViewModel

    init (viewModel: ContactsViewModel, indexInTable: Int) {
        contactsViewModel = viewModel
        fullName = viewModel.contacts[indexInTable].firstName + " " + viewModel.contacts[indexInTable].lastName
        phoneNumber = viewModel.contacts[indexInTable].telephone
        self.indexInTable = indexInTable
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var personImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.fill.badge.plus")
        imageView.layer.cornerRadius = 43
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("call", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("delete", for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var contactInfoVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    private lazy var upperHStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()

    private lazy var bottomVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var mainVStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.distribution = .equalCentering
        stack.axis = .vertical
        return stack
    }()

    override func loadView() {
        super.loadView()
        configureBackground()
        configureViews()
        addRightBarButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = fullName
        phoneNumberLabel.text = phoneNumber
        contactsViewModel.updateContactDelegate = self
    }

    private func addRightBarButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }

    @objc private func editButtonTapped() {
        let editVC = EditOrAddContactViewController(viewModel: contactsViewModel, indexInTable: indexInTable)
        let editContactNavController = UINavigationController(rootViewController: editVC)
        present(editContactNavController, animated: true)
    }

    @objc private func deleteButtonTapped() {
        contactsViewModel.deleteContact(at: indexInTable)
        navigationController?.popToRootViewController(animated: true)
    }

    private func configureBackground() {
        view.backgroundColor = .systemBackground
        title = "Contact Info"
    }

    private func configureViews() {
        [nameLabel, phoneNumberLabel].forEach(contactInfoVStack.addArrangedSubview)
        [personImage, contactInfoVStack].forEach(upperHStack.addArrangedSubview)
        [callButton, deleteButton].forEach(bottomVStack.addArrangedSubview)
        [upperHStack, bottomVStack].forEach(mainVStack.addArrangedSubview)
        view.addSubview(mainVStack)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            personImage.heightAnchor.constraint(equalToConstant: 85),
            personImage.widthAnchor.constraint(equalToConstant: 85)
        ])
    }
}

extension DetailsViewController: UpdateContactViewModelDelegate {

    func updateNameAndPhoneNumber(_ contact: Contact) {
        nameLabel.text = contact.firstName + contact.lastName
        phoneNumberLabel.text = contact.telephone
    }
}