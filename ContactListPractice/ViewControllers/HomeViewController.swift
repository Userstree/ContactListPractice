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

    var dumbData = [Contact(name: "Abbot Lisbon", number: "+7 777 123 43 32"),
                    Contact(name: "Zane Wayne", number: "+7 777 165 85 58"),
                    Contact(name: "John Hopkins", number: "+7 777 424 54 66")]

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchContacts()
    }
    
    private func fetchContacts() {

    }

    private func configureAddButton() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = add
    }

    private func setStyle() {
        view.backgroundColor = .white
        title = "Contacts"
    }

    @objc private func addButtonTapped(){
        navigationController?.pushViewController(AddContactVIewController(), animated: true)
    }

    func findContacts () -> [CNContact]{

//        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactPhoneNumbersKey]
//        let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch)
        let keyToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keyToFetch)
        var contacts = [CNContact]()

        fetchRequest.mutableObjects = false
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault

        let contactStoreID = CNContactStore().defaultContainerIdentifier()
        print("\(contactStoreID)")


        do {

//            try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) -> Void in
//                contacts.append(contact)
//            }
            try CNContactStore().enumerateContacts(with: fetchRequest) { contact, stop in
                
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }

        return contacts

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
        let contactInfoVC = ContactInfoViewController(contactName: dumbData[indexPath.row].name, phoneNumber: dumbData[indexPath.row].number)
        self.navigationController?.pushViewController(contactInfoVC, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dumbData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as! ContactCell
        cell.bind(with: dumbData[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

