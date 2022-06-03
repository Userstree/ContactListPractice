//
// Created by Dossymkhan Zhulamanov on 01.06.2022.
//

import UIKit

class ContactCell: UITableViewCell {

    static let identifier = "ContactCell"

    private lazy var personImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var phoneNumber: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private lazy var mainHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .top
        stack.spacing = 10
        return stack
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }

    func bind(with model: Contact) {
        self.name.text = model.name
        self.phoneNumber.text = model.number
    }

    private func configureViews() {
        [name, phoneNumber].forEach(verticalStack.addArrangedSubview)
        [personImage, verticalStack].forEach(mainHorizontalStack.addArrangedSubview)
        contentView.addSubview(mainHorizontalStack)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            personImage.heightAnchor.constraint(equalToConstant: 80),
            personImage.widthAnchor.constraint(equalToConstant: 70)
        ])

        NSLayoutConstraint.activate([
            mainHorizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainHorizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainHorizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainHorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
