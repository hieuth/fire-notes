//
//  AppDelegate.swift
//  mvvm-structure
//
//  Created by Hieu Huynh on 5/18/17.
//  All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(
        _ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        // support offline data save
        FIRDatabase.database().persistenceEnabled = true
        return true
    }
}
