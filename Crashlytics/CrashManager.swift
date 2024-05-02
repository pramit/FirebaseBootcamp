//
//  CrashManager.swift
//  FirebaseBootcamp
//
//  Created by Pramit Rashinkar on 8/29/23.
//

import Foundation
import FirebaseCrashlytics

final class CrashManager {
    
    static let shared = CrashManager()
    private init() { }
    
    func setUserId(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }
    
    // ADDING KEYS - attributes to help you debug, eg is user a premium member, in an A/B test, etc
    private func setValue(value: String, key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    func setIsPremiumValue(isPremium: Bool) {
        setValue(value: isPremium.description.lowercased(), key: "user_is_premium")
    }
    
    // ADDING LOGS - wwhat the user was doing leading up to crash
    func addLog(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    func sendNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
}
