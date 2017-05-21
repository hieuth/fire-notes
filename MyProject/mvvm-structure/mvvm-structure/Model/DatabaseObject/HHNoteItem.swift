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
    static let dateFormatString = "dd/MM/YY"
    let key: String!
    let title: String?
    let addedByUser: String?
    let content: String?
    var lastUpdated: Date?
    let ref: FIRDatabaseReference?
    var lastUpdatedDateString: String? {
        guard let nonOptionalDate = lastUpdated else {
            return nil
        }
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = HHNoteItem.dateFormatString
        return dateFormat.string(from: nonOptionalDate)
    }
    init(title: String, content: String, addedByUser: String, key: String = "") {
        self.key = key
        self.title = title
        self.addedByUser = addedByUser
        self.ref = nil
        self.content = content
        self.lastUpdated = Date()
    }
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        // swiftlint:disable force_cast
        let snapshotValue = snapshot.value as? [String: AnyObject]
        title = snapshotValue?["title"] as? String
        addedByUser = snapshotValue?["addedByUser"] as? String
        content = snapshotValue?["content"] as? String
        if let lastUpdatedString = snapshotValue?["lastUpdated"] as? String {
            let format = DateFormatter()
            format.dateFormat = HHNoteItem.dateFormatString
            lastUpdated = format.date(from: lastUpdatedString)
        }
        ref = snapshot.ref
    }
    func toAnyObject() -> Any {
        return [
            "title": title,
            "content": content,
            "addedByUser": addedByUser,
            "key": key,
            "lastUpdated": lastUpdatedDateString
        ]
    }
}
