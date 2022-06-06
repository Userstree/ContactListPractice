//
//  ViewController.swift
//  Contacts
//
//  Created by Dossymkhan Zhulamanov on 01.06.2022.
//
//

import UIKit
import Contacts


class HomeViewController: UIViewController {

    var contacts = [Contact]()

    private lazy var table: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func loadView() {
        super.loadView()
        // Do any additional setup after loading the view.
        setStyle()
        configureAddButton()
        configureViews()
        fetchContacts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private func configureAddButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = add
    }

    private func setStyle() {
        view.backgroundColor = .white
        title = "Contacts"
    }

    @objc private func addButtonTapped() {
        navigationController?.pushViewController(EditOrAddContactViewController(), animated: true)
    }

    private func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(Contact(firstName: contact.givenName,
                                lastName: contact.familyName,
                                telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }

    private func configureViews() {
        view.addSubview(table)
        makeConstraints()
    }

    private func makeConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension HomeViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contactInfoVC = DetailsViewController(contactName: (contacts[indexPath.row].firstName + " " + contacts[indexPath.row].lastName), phoneNumber: contacts[indexPath.row].telephone)
        self.navigationController?.pushViewController(contactInfoVC, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as! ContactCell
        cell.bind(with: contacts[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension HomeViewController: SaveContactDelegate {

    func saveWith(name: String, phoneNumber: String) {

    }
}
