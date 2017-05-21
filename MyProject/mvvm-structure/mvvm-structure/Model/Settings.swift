//
//  Settings.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/21/17.
//  All rights reserved.
//

import Foundation
struct Settings {
    private static let mailKey = "mailKey"
    static var email: String? {
        get {
            return userDefaultsObjectForKey(key: mailKey) as? String
        }
        set {
            setUserDefaultsObject(value: newValue as AnyObject?, forKey: mailKey)
        }
    }
    private static func setUserDefaultsObject(value: AnyObject?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private static func userDefaultsObjectForKey(key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
}
