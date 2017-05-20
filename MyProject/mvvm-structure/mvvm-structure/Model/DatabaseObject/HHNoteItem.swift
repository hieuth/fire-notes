//
//  HHNoteItem.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import UIKit
import FirebaseDatabase

struct HHNoteItem {
    let key: String
    let name: String
    let addedByUser: String
    let content: String
    let lastUpdated: Date
    let ref: FIRDatabaseReference?
    var lastUpdatedDateString: String {
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "dd/MM/YY"
        return dateFormat.string(from: lastUpdated)
    }
    init(name: String, content: String, addedByUser: String, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.ref = nil
        self.content = content
        self.lastUpdated = Date()
    }
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        // swiftlint:disable force_cast
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        content = snapshotValue["content"] as! String
        // TODO: get last updated date from FIR
        lastUpdated = Date()
        ref = snapshot.ref
    }
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser
        ]
    }
}
