//
//  HHNotesViewController.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HHNotesViewController: UITableViewController {
    // MARK: Constants
    let listToUsers = "ListToUsers"
    let notesRef = FIRDatabase.database().reference(withPath: "notes")
    // MARK: Properties
    var items: [HHNoteItem] = []
    var user: User?
    var authStateHandle: FIRAuthStateDidChangeListenerHandle?
    // MARK: Overriden
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        // get data from FIR
        notesRef.childByAutoId()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStateHandle = FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = authStateHandle {
            FIRAuth.auth()?.removeStateDidChangeListener(handle)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let noteComposerVC = segue.destination as? HHNoteComposerViewController {
            noteComposerVC.delegate = self
        }
    }
    // MARK: - Actions
    // MARK: Logout
    @IBAction func logoutPressed(_ sender: AnyObject) {
        UIAlertController.show(in: self, withTitle: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout", otherButtonTitles: nil, popoverPresentationControllerBlock: nil) { [weak self](alertController, action, index) in
            if index == UIAlertControllerBlocksDestructiveButtonIndex {
                if let strongSelf = self {
                    // perform logout
                    do {
                        try FIRAuth.auth()!.signOut()
                        strongSelf.dismiss(animated: true, completion: nil)
                    } catch {
                        UIAlertController.showAlert(message: error.localizedDescription, from: strongSelf)
                    }
                }
            }
        }
    }
}
// MARK: UITableView Delegate & Datasource methods
extension HHNotesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let noteItem = items[indexPath.row]
        cell.textLabel?.text = noteItem.title == "" ? noteItem.content : noteItem.title
        var detailText = "\(noteItem.content ?? "")"
        if let lastUpdated = noteItem.lastUpdated {
            detailText = Utils.dynamicDateString(from: lastUpdated) + " " + detailText
        }
        cell.detailTextLabel?.text = detailText
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) != nil else { return }
        //        var groceryItem = items[indexPath.row]
        //        let toggledCompletion = !groceryItem.completed
        
        //        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        //        groceryItem.completed = toggledCompletion
        tableView.reloadData()
    }
}
// MARK: HHNoteComposerVCDelegate
extension HHNotesViewController: HHNoteComposerVCDelegate {
    func noteComposerDidFinishComposing(withTitle title: String?, content: String?) {
        let titleCount = title?.characters.count ?? 0
        let contentCount = content?.characters.count ?? 0
        // ensure at least 1 characters was input for both title and content
        guard (titleCount + contentCount) > 0 else {
            return
        }
        // create a new note object from title, content
        let noteObject = HHNoteItem(title: title ?? "", content: content ?? "", addedByUser: self.user?.email ?? "")
        // create a new child ref from root ref node with auto gen key
        let noteItemRef = self.notesRef.childByAutoId()
        // set value for the database ref
        noteItemRef.setValue(noteObject.toAnyObject())
        // insert new item to current list
        items.insert(noteObject, at: 0)
        self.tableView.reloadData()
    }
}
