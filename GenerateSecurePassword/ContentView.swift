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
    var body: some View {
        TabView {
            PasswordView()
                .tabItem {
                    Label("Password", systemImage: "lock")
                }
            PasswordStorageView()
                .tabItem {
                    Label("Key", systemImage: "key")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
