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
    let key: String!
    let title: String?
    let addedByUser: String?
    let content: String?
    var lastUpdated: Double?
    var ref: FIRDatabaseReference?
    init(title: String, content: String, addedByUser: String, key: String = "") {
        self.key = key
        self.title = title
        self.addedByUser = addedByUser
        self.ref = nil
        self.content = content
        self.lastUpdated = Date().timeIntervalSince1970
    }
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        // swiftlint:disable force_cast
        let snapshotValue = snapshot.value as? [String: AnyObject]
        title = snapshotValue?["title"] as? String
        addedByUser = snapshotValue?["addedByUser"] as? String
        content = snapshotValue?["content"] as? String
        lastUpdated = snapshotValue?["lastUpdated"] as? Double
        ref = snapshot.ref
    }
    func toAnyObject() -> Any {
        return [
            "title": title ?? "",
            "content": content ?? "",
            "addedByUser": addedByUser ?? "",
            "lastUpdated": lastUpdated ?? 0
        ]
    }
}
