//
//  HHNotesViewModel.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/22/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import Foundation

import FirebaseDatabase
class HHNotesViewModel {
    // MARK: - Properties
    fileprivate unowned let vc: HHNotesViewController
    fileprivate let notesRef = FIRDatabase.database().reference(withPath: "notes")
    fileprivate var authStateHandle: FIRAuthStateDidChangeListenerHandle?
    fileprivate var dataStateHandle: UInt = 0
    fileprivate var items: [HHNoteItem] = []
    fileprivate var isUpToDate = false
    fileprivate var user: HHUser?
    fileprivate var editingIndex = -1
    fileprivate let cellToComposer = "CellToComposer"
    // MARK: - Constructor
    init(viewController: HHNotesViewController) {
        vc = viewController
    }
    // MARK: - internal functions
    var numberOfItems: Int {
        return items.count
    }
    func itemAt(index: Int) -> HHNoteItem {
        return items[index]
    }
    func handleLogout() {
        UIAlertController.show(in: vc, withTitle: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Logout", otherButtonTitles: nil, popoverPresentationControllerBlock: nil) { [weak self](alertController, action, index) in
            if index == UIAlertControllerBlocksDestructiveButtonIndex {
                if let strongSelf = self {
                    // perform logout
                    Settings.email = nil
                    do {
                        try FIRAuth.auth()!.signOut()
                        strongSelf.vc.dismiss(animated: true, completion: nil)
                    } catch {
                        UIAlertController.showAlert(message: error.localizedDescription, from: strongSelf.vc)
                    }
                }
            }
        }
    }
    func handlePrepare(`for` segue: UIStoryboardSegue, sender: Any?) {
        if let noteComposerVC = segue.destination as? HHNoteComposerViewController {
            noteComposerVC.delegate = self
            // if it's edit mode, pass the existed data
            if segue.identifier == cellToComposer, let cell = sender as? UITableViewCell {
                if let indexPath = vc.tableView.indexPath(for: cell) {
                    let note = items[indexPath.row]
                    noteComposerVC.note = note
                    editingIndex = indexPath.row
                }
            }
        }
    }
    func handleDeinit() {
        notesRef.removeObserver(withHandle: dataStateHandle)
    }
    func handleViewWillAppear() {
        authStateHandle = FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = HHUser(authData: user)
        }
    }
    func handleViewWillDisappear() {
        if let handle = authStateHandle {
            FIRAuth.auth()?.removeStateDidChangeListener(handle)
        }
    }
    func refreshData() {
        // get data from FIR
        // create a query that order data by last updated date
        let notesQuery = notesRef.queryOrdered(byChild:"lastUpdated")
        // observe query to get data
        dataStateHandle =  notesQuery.observe(.value, with: { [weak self](snapshot) in
            self?.items.removeAll()
            // filter only notes from this user
            let array = snapshot.children.filter{ item -> Bool in
                let snpShot = item as! FIRDataSnapshot
                let value = snpShot.value as! [String: AnyObject]
                return (value["addedByUser"] as! String) == Settings.email
            }
            // iterate through items to add to current list
            for item in array.reversed() { // reverse the list to make newest displayed first
                let note = HHNoteItem(snapshot: item as! FIRDataSnapshot)
                self?.items.append(note)
            }
            self?.vc.tableView.reloadData()
            self?.isUpToDate = true
            self?.vc.refreshControl?.endRefreshing()
        })
    }
    
}
// MARK: HHNoteComposerVCDelegate
extension HHNotesViewModel: HHNoteComposerVCDelegate {
    func noteComposerDidFinishComposing(note: HHNoteItem) {
        isUpToDate = false
        if note.ref == nil {
            addNewNote(note)
        } else {
            updateNote(note)
        }
        vc.tableView.reloadData()
    }
    fileprivate func addNewNote(_ note: HHNoteItem) {
        let titleCount = note.title?.characters.count ?? 0
        let contentCount = note.content?.characters.count ?? 0
        // ensure at least 1 characters was input for both title and content
        guard (titleCount + contentCount) > 0 else {
            return
        }
        var newNote = note
        let noteRef = self.notesRef.childByAutoId()
        newNote.ref = noteRef
        noteRef.setValue(note.toAnyObject())
        noteRef.setValue(note.toAnyObject()) {[weak self] (error, ref) in
            guard self?.isUpToDate == false else {
                return
            }
            self?.items.insert(newNote, at: 0)
        }
    }
    func updateNote(_ note: HHNoteItem) {
        var updateNote = note
        updateNote.lastUpdated = Date().timeIntervalSince1970
        updateNote.ref?.updateChildValues(updateNote.toAnyObject() as! [AnyHashable : Any], withCompletionBlock: { [weak self](error, ref) in
            guard self?.isUpToDate == false else {
                return
            }
            if let index = self?.editingIndex, index >= 0 {
                self?.items[index] = note
            }
        })
    }
}
