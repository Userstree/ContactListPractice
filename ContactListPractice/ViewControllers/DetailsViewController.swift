//
// Created by Dossymkhan Zhulamanov on 02.06.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    private var name: String = ""
    private var phoneNumber: String = ""

    init(contactName: String, phoneNumber: String) {
        super.init(nibName: nil, bundle: nil)
        self.name = contactName
        self.phoneNumber = phoneNumber
        self.personImage.image = UIImage(named: "male.jpeg")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var contactInfoVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    private lazy var upperHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()

    private lazy var bottomVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var mainVerticalStack: UIStackView = {
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
        self.nameLabel.text = name
        self.phoneNumberLabel.text = phoneNumber
        setDelegates()
    }

    private func setDelegates() {
        let editVC = EditOrAddContactViewController()
        editVC.editDelegate = self
    }

    private func addRightBarButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }

    @objc private func editButtonTapped() {
        let editContactNavController = UINavigationController(rootViewController: EditOrAddContactViewController(name: name, phoneNumber: phoneNumber))
        self.modalPresentationStyle = .formSheet
        self.present(editContactNavController, animated: true)
    }

    private func configureBackground() {
        view.backgroundColor = .systemBackground
        title = "Contact Info"
    }

    private func configureViews() {
        [nameLabel, phoneNumberLabel].forEach(contactInfoVerticalStack.addArrangedSubview)
        [personImage, contactInfoVerticalStack].forEach(upperHorizontalStack.addArrangedSubview)
        [callButton, deleteButton].forEach(bottomVerticalStack.addArrangedSubview)
        [upperHorizontalStack, bottomVerticalStack].forEach(mainVerticalStack.addArrangedSubview)
        view.addSubview(mainVerticalStack)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainVerticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainVerticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainVerticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainVerticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            personImage.heightAnchor.constraint(equalToConstant: 85),
            personImage.widthAnchor.constraint(equalToConstant: 85)
        ])
    }
}

extension DetailsViewController: EditContactDelegate {

    func editedWith(name: String, phoneNumber: String, gender: String) {
        self.nameLabel.text = name
        self.phoneNumberLabel.text = phoneNumber
        print(name, " and ", phoneNumber)
    }
}