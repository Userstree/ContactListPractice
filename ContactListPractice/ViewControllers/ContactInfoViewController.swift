//
// Created by Dossymkhan Zhulamanov on 02.06.2022.
//

import UIKit

class ContactInfoViewController: UIViewController {

    private lazy var personImage:               UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.fill.badge.plus")
        return imageView
    }()

    private lazy var nameLabel:                 UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private lazy var phoneNumberLabel:          UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private lazy var callButton:                UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("call", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var deleteButton:              UIButton = {
        let button = UIButton()
        button.setTitle("delete", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        return button
    }()

    private lazy var contactInfoVerticalStack:  UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    private lazy var upperHorizontalStack:      UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()

    private lazy var bottomVerticalStack:       UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var mainVerticalStack:         UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.distribution = .equalCentering
        stack.axis = .vertical
        return stack
    }()

    init(contactName: String, phoneNumber: String ) {
        super.init(nibName: nil, bundle: nil)
        self.nameLabel.text = contactName
        self.phoneNumberLabel.text = phoneNumber
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        super.loadView()
        configureBackground()
        configureViews()
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
