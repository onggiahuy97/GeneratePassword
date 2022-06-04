//
//  PasswordStorageView.swift
//  GenerateSecurePassword
//
//  Created by Huy Ong on 5/30/22.
//

import SwiftUI
import LocalAuthentication

struct PasswordStorageView: View {
    @EnvironmentObject var viewModel: PasswordViewModel
    
    @State private var isUnlocked = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isUnlocked {
                    PasswordList
                } else {
                    Text("Locked")
                }
            }
            .onAppear(perform: authenticate)
        }
    }
    
    var PasswordList: some View {
        List {
            ForEach(viewModel.passwords) { password in
                PasswordCell(password)
            }
            .onDelete(perform: deletePassword(_:))
        }
        .navigationTitle("Passwords")
    }
    
    func PasswordCell(_ password: Password) -> some View {
        NavigationLink(destination: PasswordDetailView(password)) {
            VStack(alignment: .leading) {
                Text(password.name)
                Text(password.password)
                    .foregroundColor(.secondary)
                if let url = password.url {
                    Button(url) {
                        print("Open URL")
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
    
    func deletePassword(_ indexSet: IndexSet) {
        withAnimation { viewModel.removePassword(at: indexSet) }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    self.isUnlocked = true
                } else {
                    print("Error: \(error?.localizedDescription ?? "Failed to authenticate")")
                }
            }
        }
    }
}

struct PasswordStorageView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordStorageView()
    }
}
