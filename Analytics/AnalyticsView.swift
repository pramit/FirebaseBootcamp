//
//  AnalyticsView.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/29/23.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAnalyticsSwift

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    private init() { }
    
    func logEvent(name: String, params: [String:Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
    
    // eg, no user profiles but creates audience profile who trigger analytics
    func setUserId(userId: String) {
        // Examples here: https://firebase.google.com/docs/analytics/user-properties?platform=ios
        
        Analytics.setUserID(userId)
    }
    
    // eg, premium member, A/B test they're in, which country, etc
    func setUserProperty(value: String?, property: String) {
        // Consider recommended events per https://support.google.com/firebase/answer/6317498
        Analytics.setUserProperty(value, forName: property)
    }
    
}

struct AnalyticsView: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("Click me!") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_ButtonClick")
            }
            
            Button("Click me too!") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_SecondaryButtonClick", params: [
                    "screen_title" : "Hello, world!"
                ])
            }
        }
        .analyticsScreen(name: "AnalyticsView")
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "AnalyticsView_Appear")
        }
        .onDisappear {
            AnalyticsManager.shared.logEvent(name: "AnalyticsView_Disppear")
            
            AnalyticsManager.shared.setUserId(userId: "ABC123")
            AnalyticsManager.shared.setUserProperty(value: true.description, property: "user_is_premium")
        }
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
