//
//  PasswordDetailView.swift
//  GenerateSecurePassword
//
//  Created by Huy Ong on 6/3/22.
//

import SwiftUI

struct PasswordDetailView: View {
    @EnvironmentObject var viewModel: PasswordViewModel
    @Environment(\.presentationMode) private var pm
    
    @State private var username: String
    @State private var password: String
    @State private var url: String
    @State private var userPassword: Password
    
    init(_ userPassword: Password) {
        _userPassword = State(wrappedValue: userPassword)
        _username = State(wrappedValue: userPassword.name)
        _password = State(wrappedValue: userPassword.password)
        _url = State(wrappedValue: userPassword.url ?? "")
    }
    
    var body: some View {
        Form {
            Section("Username") {
                TextField("Username", text: $username)
            }
            
            Section("Password") {
                TextField("Password", text: $password)
            }
            
            Section("URL") {
                TextField("URl", text: $url)
            }
        }
        .navigationTitle("Password Detail")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    userPassword.name = username
                    userPassword.password = password
                    userPassword.url = url
                    viewModel.updatePassword(userPassword)
                    pm.wrappedValue.dismiss()
                }
            }
        }
    }
}
