//
//  HHNoteComposerViewController.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol HHNoteComposerVCDelegate {
    func noteComposerDidFinishComposing(note: HHNoteItem)
}

class HHNoteComposerViewController: UIViewController {
    // MARK: - Properties
    var delegate: HHNoteComposerVCDelegate?
    var note: HHNoteItem?
    // MARK: - Outlets
    @IBOutlet weak var textViewToBotConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    // MARK: - Actions
    @IBAction func doneButtonPressed() {
        view.endEditing(true)
    }
    // MARK: - Overriden
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        titleTextField.text = note?.title
        contentTextView.text = note?.content
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        var note = self.note
        if note == nil {
            note = HHNoteItem(title: titleTextField.text, content: contentTextView.text, addedByUser: Settings.email)
        }
        note?.title = titleTextField.text
        note?.content = contentTextView.text
        delegate?.noteComposerDidFinishComposing(note: note!)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - fileprivate
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
    }
    @objc fileprivate func handleKeyboardWillShow(notification: Notification) {
        if let keyboardValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue  {
            textViewToBotConstraint.constant = keyboardValue.cgRectValue.size.height
        }
    }
    @objc fileprivate func handleKeyboardWillHide(notification: Notification) {
        textViewToBotConstraint.constant = 8.0
    }
}
