//
//  HHPostListResponse.swift
//  mvvm-structure
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class HHPostListResponse: HHResponseModel {
    var items: [HHPostResponse]?
    override func mapping(map: Map) {
        super.mapping(map: map)
        items <- map[""]
    }
}
