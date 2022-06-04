//
//  PasswordViewModel.swift
//  GenerateSecurePassword
//
//  Created by Huy Ong on 5/31/22.
//

import Foundation

class PasswordViewModel: ObservableObject {
    @Published var passwords: [Password] = []
    
    init() {
        reloadData()
    }
    
    func reloadData() {
        if let data = UserDefaults.standard.object(forKey: "Password") as? Data {
            if let objects = try? JSONDecoder().decode([Password].self, from: data) {
                self.passwords = objects
            }
        }
    }
    
    func save() {
        if let object = try? JSONEncoder().encode(passwords) {
            UserDefaults.standard.set(object, forKey: "Password")
            reloadData()
        }
    }
    
    func savePassword(_ password: Password) {
        self.passwords.append(password)
        if let object = try? JSONEncoder().encode(passwords) {
            UserDefaults.standard.set(object, forKey: "Password")
            reloadData()
        } else {
            self.passwords.removeAll(where: { $0.id == password.id })
        }
    }
    
    func removePassword(at indexSet: IndexSet) {
        passwords.remove(atOffsets: indexSet)
        save()
    }
    
    func updatePassword(_ password: Password) {
        if passwords.contains(where: { $0.id == password.id }) {
            let index = passwords.firstIndex(where: { $0.id == password.id })
            passwords[index!] = password
            save()
        }
    }
}

struct Password: Identifiable, Codable {
    var id = UUID()
    var name: String
    var password: String
    var url: String?
}
