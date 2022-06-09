//
// Created by Dossymkhan Zhulamanov on 08.06.2022.
//

import UIKit
import Contacts

protocol ContactsViewModelDelegate: AnyObject {
    func didUpdateContactsList(_ contacts: [Contact])
}

protocol UpdateContactViewModelDelegate: AnyObject {
    func updateNameAndPhoneNumber(_ contact: Contact)
}

class ContactsViewModel {

    init() {}

    weak var delegate: ContactsViewModelDelegate?
    weak var updateContactDelegate: UpdateContactViewModelDelegate?

    var contacts: [Contact] = []

    func initializeContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] (granted, error) in
            guard let self = self else { return }
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                var storeContacts = [Contact]()
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        storeContacts.append(Contact(firstName: contact.givenName,
                                                     lastName: contact.familyName,
                                                     telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                    })
                    self.contacts = storeContacts
                    self.delegate?.didUpdateContactsList(self.contacts)
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
}

extension ContactsViewModel {

    func deleteContact(at index: Int) {
        contacts.remove(at: index)
        delegate?.didUpdateContactsList(contacts)
    }

    func addContact(contact: Contact) {
        contacts.append(contact)
        delegate?.didUpdateContactsList(contacts)
    }

    func editContact(at index: Int, name: String, phoneNumber: String) {
        contacts[index] = Contact(firstName: name, lastName: "", telephone: phoneNumber)
        delegate?.didUpdateContactsList(contacts)
        updateContactDelegate?.updateNameAndPhoneNumber(contacts[index])
    }
}
