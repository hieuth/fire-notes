//
//  HHPostResponse.swift
//  mvvm-structure
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class HHPostResponse: HHResponseModel {
    var userId: Int?
    var postId: Int?
    var title: String?
    var body: String?
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId <- map["userId"]
        postId <- map["id"]
        title <- map["title"]
        body <- map["body"]
    }
}
