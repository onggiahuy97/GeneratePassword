//
//  PasswordView.swift
//  GenerateSecurePassword
//
//  Created by Huy Ong on 5/31/22.
//

import SwiftUI

struct PasswordView: View {
    
    @EnvironmentObject var viewModel: PasswordViewModel
    
    static let upperCaseLetterPlaceholder: String = {
        let start = UnicodeScalar("A").value
        let end = UnicodeScalar("Z").value
        let string = (start...end).reduce(into: "") { partialResult, value in
            partialResult += String(Character(UnicodeScalar(value)!))
        }
        return string
    }()
    
    static let lowerCaseLetterPlaceholder: String = {
        let start = UnicodeScalar("a").value
        let end = UnicodeScalar("z").value
        let string = (start...end).reduce(into: "") { partialResult, value in
            partialResult += String(Character(UnicodeScalar(value)!))
        }
        return string
    }()
    
    static let characters: String = "~!@#$%^&*-"
    static let numbers: String = "0123456789"
    
    @State private var upperCaseLetters: String = Self.upperCaseLetterPlaceholder
    @State private var isUsingUpperCaseLetter = true
    
    @State private var lowerCaseLetters: String = Self.lowerCaseLetterPlaceholder
    @State private var isUsingLowerCaseLetter = true
    
    @State private var charactersLetter: String = Self.characters
    @State private var isUsingCharacters = true
    
    @State private var numbersLetter: String = Self.numbers
    @State private var isUsingNumbers = true
    
    @State private var length: Double = 15
    
    @State private var randomPassword: String = ""
    
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Upper Case") {
                    TextField(Self.upperCaseLetterPlaceholder, text: $upperCaseLetters.onChange(generateRandomPassword))
                    Toggle("Enable/Disable", isOn: $isUsingUpperCaseLetter.onChange(generateRandomPassword))
                }
                
                Section("Lower Case") {
                    TextField(Self.lowerCaseLetterPlaceholder, text: $lowerCaseLetters.onChange(generateRandomPassword))
                    Toggle("Enable/Disable", isOn: $isUsingLowerCaseLetter.onChange(generateRandomPassword))
                }
                
                Section("Number") {
                    TextField(Self.numbers, text: $numbersLetter.onChange(generateRandomPassword))
                    Toggle("Enable/Disable", isOn: $isUsingNumbers.onChange(generateRandomPassword))
                }
                
                Section("Character") {
                    TextField(Self.numbers, text: $charactersLetter.onChange(generateRandomPassword))
                    Toggle("Enable/Disable", isOn: $isUsingCharacters.onChange(generateRandomPassword))
                }
                
                Section("Length: \(Int(length))") {
                    Slider(value: $length.onChange(generateRandomPassword), in: 1...30, step: 1) {
                        Text("Length")
                    } minimumValueLabel: {
                        Text("1")
                    } maximumValueLabel: {
                        Text("30")
                    }
                }
                
                Section {
                    Text(randomPassword)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button {
                        generateRandomPassword()
                    } label: {
                        Text("Generate Random Password")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.isShowingAlert.toggle()
                    } label: {
                        Label("Copy", systemImage: "doc.on.clipboard")
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text("Copied!"),
                              message: Text(self.randomPassword),
                              dismissButton: .cancel({
                            UIPasteboard.general.string = self.randomPassword
                        }))
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        let password = Password(name: "Random Password", password: self.randomPassword)
                        self.viewModel.savePassword(password)
                    } label: {
                        Label("Save", systemImage: "icloud.and.arrow.up")
                    }
                }
            }
            .onAppear { generateRandomPassword() }
        }
    }
    
    private func generateRandomPassword() {
        var finalString = ""
        
        if isUsingUpperCaseLetter { finalString.append(contentsOf: upperCaseLetters) }
        if isUsingLowerCaseLetter { finalString.append(contentsOf: lowerCaseLetters) }
        if isUsingNumbers { finalString.append(contentsOf: numbersLetter) }
        if isUsingCharacters { finalString.append(contentsOf: charactersLetter) }
        
        guard !finalString.isEmpty else {
            self.randomPassword = ""
            return
        }
        let arrayString = finalString.map { char in String(char) }
        
        // Random string
        finalString = (0..<finalString.count).reduce(into: "") { par, _ in par += arrayString.randomElement()! }
        
        // Random password
        let randomCharacters = (0..<Int(length)).map { _ in finalString.randomElement()! }
        let string = String(randomCharacters)
        
        self.randomPassword = string
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
