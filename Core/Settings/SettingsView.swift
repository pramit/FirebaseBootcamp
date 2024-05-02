//
//  SettingsView.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/26/23.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    @State var updatedEmail = ""
    @State var updatedPassword = ""
    @State var newAccountEmail = ""
    @State var newAccountPassword = ""
    
    var body: some View {
        List {
            // LOG OUT BUTTON
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print("Error logging out. \(error)")
                    }
                }
            }
            
            // DELETE BUTTON
            Button(role: .destructive) {
                Task {
                    do {
                        // usually want to show an alert, get user to reauthenticate by logging back in, and then proceeding to delete account
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print("Error logging out. \(error)")
                    }
                }
            } label: {
                Text("Delete account")
            }

            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            // also can use: if let user = viewModel.authUser, user.isAnonymous {...}
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section("Email functions") {
            
            // RESET PASSWORD
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset!")
                    } catch {
                        print("Error resetting password. \(error)")
                    }
                }
            }
            
            // UPDATE EMAIL
            HStack {
                TextField("Update email here...", text: $updatedEmail)
                    .frame(width: 200)
                Spacer()
                Button("Update") {
                    Task {
                        do {
                            try await viewModel.updateEmail(email: updatedEmail)
                            print("Email updated!")
                            updatedEmail = ""
                        } catch {
                            print("Error resetting password. \(error)")
                        }
                    }
                }
            }
            
            // UPDATE PASSWORD
            HStack {
                TextField("Update password here...", text: $updatedPassword)
                    .frame(width: 200)
                Spacer()
                Button("Update") {
                    Task {
                        do {
                            try await viewModel.updatePassword(password: updatedPassword)
                            print("Password updated!")
                            updatedPassword = ""
                        } catch {
                            print("Error resetting password. \(error)")
                        }
                    }
                }
            } 
        }
    }
    
    private var anonymousSection: some View {
        Section("Create accounts") {
            
            // LINK GOOGLE ACCOUNT
            Button("Link Google Account") {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                        print("Google account linked!")
                    } catch {
                        print("Could not link to Google account. \(error)")
                    }
                }
            }
            
            // LINK APPLE ACCOUNT
            Button("Link Apple Account") {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                        print("Apple account linked!")
                        updatedEmail = ""
                    } catch {
                        print("Could not link to Apple account. \(error)")
                    }
                }
            }
            
            // LINK EMAIL + PASSWORD ACCOUNT
            HStack {
                VStack {
                    TextField("Update email here...", text: $newAccountEmail)
                        .frame(width: 200)
                    SecureField("Update password here...", text: $newAccountPassword)
                        .frame(width: 200)
                }
                
                Button("Link Email Account") {
                    Task {
                        do {
                            try await viewModel.linkEmailAccount(email: newAccountEmail, password: newAccountPassword)
                            print("Email linked!")
                            newAccountPassword = ""
                        } catch {
                            print("Could not link to email + password account. \(error)")
                        }
                    }
                }
                .disabled(newAccountEmail.isEmpty || newAccountPassword.isEmpty)
                .foregroundColor((newAccountEmail.isEmpty || newAccountPassword.isEmpty) ? .gray : .blue)
            }
        }
    }
}
