//
//  AuthenticationView.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/26/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import _AuthenticationServices_SwiftUI
import CryptoKit

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Button {
                Task {
                    do {
                        try await viewModel.signInAnonymous()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
                
            } label: {
                // usually no button, happens behind the scenes
                Text("Sign in Anyonymously")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            }

            
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign in with email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.signInApple()
                        showSignInView = false
                    } catch {
                        print(error)
                    }
                }
            } label: {
                SignInWithAppleButtonViewRepresentable(type: .default, style: .white)
                    .allowsHitTesting(false)
            }
            .frame(height: 55)
            
            //fireBaseAppleButton
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Sign In")
        
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}


// https://www.youtube.com/watch?v=HyiNbqLOCQ8
extension AuthenticationView {
    private var fireBaseAppleButton: some View {
        SignInWithAppleButton { request in
            viewModel.handleSignInWithAppleRequest(request)
        } onCompletion: { result in
            viewModel.handleSignInWithAppleCompletion(result)
        }
        .frame(height: 55)
        .frame(maxWidth: .infinity)
    }
}


