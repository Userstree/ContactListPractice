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

    var viewModel: ContactsViewModel?

    var contacts: [Contact] {
        didSet {
            if contacts.isEmpty {
                view.bringSubviewToFront(noContactsMessageLabel)
            } else {
                view.addSubview(table)
                view.bringSubviewToFront(table)
            }
            table.reloadData()
        }
    }

    init(contacts: [Contact]) {
        self.contacts = contacts
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder, contacts: [Contact]) {
        self.contacts = contacts
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var noContactsMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "No contacts"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
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
        setStyle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAddButton()
        configureTable()
        configureViewModel()
    }

    private func configureViewModel() {
        viewModel = ContactsViewModel()
        viewModel?.delegate = self
        viewModel?.initializeContacts()
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
        guard let viewModel = viewModel else { return }
        let editVC = EditOrAddContactViewController(viewModelAndDefault: viewModel)
        navigationController?.pushViewController(editVC, animated: true)
    }

    private func configureTable() {
        view.addSubview(table)
        view.addSubview(noContactsMessageLabel)
        makeTableConstraints()
        makeConstraintsForLabel()
    }

    private func makeTableConstraints()  {

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func makeConstraintsForLabel() {

        NSLayoutConstraint.activate([
            noContactsMessageLabel.heightAnchor.constraint(equalToConstant: 25),
            noContactsMessageLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            noContactsMessageLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        let contactInfoVC = DetailsViewController(viewModel: viewModel, indexInTable: indexPath.row)

        navigationController?.pushViewController(contactInfoVC, animated: true)
    }
}

extension HomeViewController: ContactsViewModelDelegate {

    func didUpdateContactsList(_ contacts: [Contact]) {
        self.contacts = contacts
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

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
