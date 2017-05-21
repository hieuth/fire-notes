//
//  HHLoginViewModel.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/22/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import Foundation

class HHLoginViewModel {
    // MARK: - Properties
    let loginToList = "LoginToList"
    var authStateHandle: FIRAuthStateDidChangeListenerHandle?
    unowned let vc: HHLoginViewController
    // MARK: - Constructor
    init(viewController: HHLoginViewController) {
        self.vc = viewController
    }
    // MARK: - internal functions
    func checkUserLoginStatus() {
        // check user login status
        authStateHandle = FIRAuth.auth()!.addStateDidChangeListener() {[weak self] auth, user in
            if user != nil, let strongSelf = self {
                strongSelf.vc.performSegue(withIdentifier: strongSelf.loginToList, sender: nil)
            }
        }
    }
    func handleSignUpPressed() {
        let alert = createSignUpAlert()
        // present alert
        vc.present(alert, animated: true, completion: nil)
    }
    func handleLoginPressed() {
        vc.view.endEditing(true)
        // TODO: Validate email & password before call API
        // perform login
        LoadingView.show("Logging in...")
        FIRAuth.auth()!.signIn(withEmail: vc.emailField.text!, password: vc.passwordField.text!) {[weak self] (user, error) in
            DispatchQueue.main.async {
                LoadingView.hide()
            }
            guard error == nil else {
                if let strongSelf = self {
                    UIAlertController.showAlert(message: error!.localizedDescription, from: strongSelf.vc)
                }
                return
            }
            Settings.email = user?.email
            if let strongSelf = self {
                strongSelf.vc.performSegue(withIdentifier: strongSelf.loginToList, sender: nil)
            }
        }
    }
    // MARK: fileprivate functions
    /// Creates a sign up alert controller
    ///
    /// - Returns: a sign up alert controller
    fileprivate func createSignUpAlert() -> UIAlertController {
        // init alert
        let alert = UIAlertController(title: "Sign up",
                                      message: nil,
                                      preferredStyle: .alert)
        // setup sign up action
        let signUpAction = UIAlertAction(
            title: "Sign up",
            style: .default) {[weak self] _ in
                guard let email = alert.textFields?[0].text else {return}
                guard let password = alert.textFields?[1].text else {return}
                self?.signupUser(email: email, password: password)
        }
        // setup cancel action
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        // add text fields to alert
        alert.addTextField { emailField in
            emailField.placeholder = "Enter your email"
        }
        alert.addTextField { passwordField in
            passwordField.isSecureTextEntry = true
            passwordField.placeholder = "Enter your password"
        }
        // add actions to alert
        alert.addAction(signUpAction)
        alert.addAction(cancelAction)
        return alert
    }
    /// Call Firebase API to sign up a new user
    ///
    /// - Parameters:
    ///   - email: email
    ///   - password: password
    fileprivate func signupUser(email: String, password: String) {
        if let handle = authStateHandle {
            FIRAuth.auth()?.removeStateDidChangeListener(handle)
        }
        LoadingView.show()
        FIRAuth.auth()!.createUser(
            withEmail: email,
            password: password) {[weak self] _, error in
                LoadingView.hide()
                if let strongSelf = self {
                    if error == nil {
                        UIAlertController.showAlert(withTitle: "Congrats!",message: "Your account was created", from: strongSelf.vc)
                    } else {
                        UIAlertController.showAlert(message: error?.localizedDescription, from: strongSelf.vc)
                    }
                }
        }
    }
}
