//
//  SignInGoogleHelper.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/26/23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import Firebase
import FirebaseAuth

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }

        let accessToken = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email

        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
    
    // as seen in https://www.youtube.com/watch?v=IzyOdKm0bWE&t
    func googVideoSignIn() async throws -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client found in Firebase configuration")
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("There is no root view controller")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw URLError(.badServerResponse)
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
