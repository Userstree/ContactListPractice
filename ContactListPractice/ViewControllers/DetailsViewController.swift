//
// Created by Dossymkhan Zhulamanov on 02.06.2022.
//

import UIKit

protocol PassInfoToHomeDelegate: AnyObject {
    func modifyWith(fullName: String, phoneNumber: String, indexInTable: Int)
}

class DetailsViewController: UIViewController {

    weak var passInfoDelegate: PassInfoToHomeDelegate?

    private var fullName: String = ""
    private var phoneNumber: String = ""
    private var indexInTable: Int = 0

    init(fullName: String, phoneNumber: String, indexInTable: Int) {
        super.init(nibName: nil, bundle: nil)
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.indexInTable = indexInTable
        self.personImage.image = UIImage(named: "male.jpeg")
    }

    convenience init() {
        self.init(fullName: "Name", phoneNumber: "Number", indexInTable: 0)
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
        self.nameLabel.text = fullName
        self.phoneNumberLabel.text = phoneNumber
    }

    private func addRightBarButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let number = phoneNumberLabel.text else {
            return
        }

        guard let name = nameLabel.text else {
            return
        }

        passInfoDelegate?.modifyWith(fullName: name, phoneNumber: number, indexInTable: indexInTable)
    }

    @objc private func editButtonTapped() {
        let editVC = EditOrAddContactViewController(fullName: fullName, phoneNumber: phoneNumber, indexInTable: indexInTable)
        editVC.editDelegate = self
        let editContactNavController = UINavigationController(rootViewController: editVC)
        self.modalPresentationStyle = .formSheet
        self.present(editContactNavController, animated: true)
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

extension DetailsViewController: EditContactDelegate {

    func editWith(fullName: String, phoneNumber: String, indexInTable: Int) {
        self.nameLabel.text = fullName
        self.phoneNumberLabel.text = phoneNumber
//        self.fullName = fullName
//        self.phoneNumber = phoneNumber
    }
}