//
//  HHUser.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import Foundation
import FirebaseAuth

struct HHUser {
    let uid: String
    let email: String
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
