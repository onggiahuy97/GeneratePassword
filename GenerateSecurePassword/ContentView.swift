//
//  ContentView.swift
//  GenerateSecurePassword
//
//  Created by Huy Ong on 5/27/22.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding {
        return Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
            handler()
        }
    }
    
    func onChange(_ handler: Void) -> Binding {
        return Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
            handler
        }
    }
}

struct ContentView: View {
    
    static let upperCaseLetterPlaceholder: String = {
        let start = UnicodeScalar("A").value
        let end = UnicodeScalar("Z").value
        let string = (start...end).reduce(into: "") { partialResult, value in
            partialResult += String(Character(UnicodeScalar(value)!))
        }
        return string
    }()
    
    static let lowerCaseLetterPlaceholder: String = {
        Self.upperCaseLetterPlaceholder.lowercased()
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        UIPasteboard.general.setValue(self.randomPassword, forPasteboardType: "txt.plain-txt")
                    } label: {
                        Label("Copy", systemImage: "doc.on.clipboard")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
