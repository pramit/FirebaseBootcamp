//
//  AuthenticationVIewModel.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/27/23.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    // for extensions below
    fileprivate var currentNonce: String?
    private var errorMessage: String = ""
    let signInAppleHelper = SignInAppleHelper()
    
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
        //try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}



extension AuthenticationViewModel {
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        //let signInAppleHelper = SignInAppleHelper.shared
        
        request.requestedScopes = [.fullName, .email]
        let nonce = signInAppleHelper.randomNonceString()
        currentNonce = nonce
        request.nonce = signInAppleHelper.sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: AuthProviderOption.apple.rawValue, idToken: idTokenString, rawNonce: nonce)
                
                Task {
                    do {
                        try await Auth.auth().signIn(with: credential)
                    } catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
