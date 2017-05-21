//
//  HHNotesViewController.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/20/17.
//  All rights reserved.
//

import UIKit

class HHNotesViewController: UITableViewController {
    // MARK: Properties
    var viewModel: HHNotesViewModel!
    // MARK: Overriden
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HHNotesViewModel(viewController: self)
        tableView.allowsMultipleSelectionDuringEditing = false
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(controlDidRefresh), for: .valueChanged)
        DispatchQueue.main.async {
            self.refreshControl?.beginRefreshing()
            self.viewModel.refreshData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.handleViewWillAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.handleViewWillDisappear()
    }
    deinit {
        viewModel.handleDeinit()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel.handlePrepare(for: segue, sender: sender)
    }
    // MARK: - Actions
    @IBAction func logoutPressed(_ sender: AnyObject) {
        viewModel.handleLogout()
    }
    // MARK: - fileprivate functions
    @objc fileprivate func controlDidRefresh() {
        viewModel.refreshData()
    }
}
// MARK: UITableView Delegate & Datasource methods
extension HHNotesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let noteItem = viewModel.itemAt(index: indexPath.row)
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
            let noteObject = viewModel.itemAt(index: indexPath.row)
            noteObject.ref?.removeValue()
            tableView.reloadData()
        }
    }
}
