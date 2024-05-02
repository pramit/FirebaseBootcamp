//
//  RootView.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/26/23.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                TabbarView(showSignInView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = (authUser == nil) // true or false
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
