//
//  HHLoginViewController.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/20/17.
//  All rights reserved.
//

import UIKit
import FirebaseAuth

class HHLoginViewController: UIViewController {
    var viewModel: HHLoginViewModel!
    // MARK: Properties
    var authStateHandle: FIRAuthStateDidChangeListenerHandle?
    // MARK: - Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    // MARK: - Actions
    @IBAction func signUpPressed() {
        viewModel.handleSignUpPressed()
    }
    @IBAction func loginPressed() {
        viewModel.handleLoginPressed()
    }
    // MARK: - Overriden 
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HHLoginViewModel(viewController: self)
        setupGestures()
        viewModel.checkUserLoginStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordField.text = ""
    }
    // MARK: - fileprivate methods
    /// Setup gestures in the view
    func setupGestures() {
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    /// Handle view tapped to hide keyboard
    @objc fileprivate func viewTapped() {
        view.endEditing(true)
    }
}
