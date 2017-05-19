//
//  HHResponseError.swift
//  mvvm-structure
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class HHResponseError: Mappable {
    var code: Int?
    var message: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
    }
}
