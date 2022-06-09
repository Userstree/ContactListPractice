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
        let name = model.firstName + " " + model.lastName
        self.name.text = name
        phoneNumber.text = model.telephone
        personImage.image = imageWith(name: name)
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

    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .lightGray
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.layer.cornerRadius = 25
        nameLabel.clipsToBounds = true
        var initials = ""

        guard let initialsArray = name?.components(separatedBy: " ") else {
            return nil
        }

        if let firstWord = initialsArray.first, let firstLetter = firstWord.first {
            initials += String(firstLetter).capitalized
        }
        if initialsArray.count > 1, let lastWord = initialsArray.last {
            if let lastLetter = lastWord.first {
                initials += String(lastLetter).capitalized
            }
        }

        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }

}
