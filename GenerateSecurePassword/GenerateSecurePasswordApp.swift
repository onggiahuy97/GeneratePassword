//
//  GenerateSecurePasswordApp.swift
//  GenerateSecurePassword
//
//  Created by Huy Ong on 5/27/22.
//

import SwiftUI

@main
struct GenerateSecurePasswordApp: App {
    @StateObject var viewModel = PasswordViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
