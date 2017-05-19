//
//  HHResponseModel.swift
//  mvvm-structure
//
//  Created by Hieu Huynh on 5/20/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import UIKit
import ObjectMapper

class HHResponseModel: NSObject, Mappable {
    var code: Int?
    var message: String?
    var requestId: String?
    var tokenError: String?
    var errors: [HHResponseError]?
    var errorMessage: String? {
            var errMessage = ""
            if let errs = self.errors {
                for error in errs {
                    if let messag = error.message {
                        errMessage.append(messag)
                    }
                }
            }
            return errMessage
    }
    required init?(map: Map) {
    }
    // Mappable
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        requestId <- map["requestId"]
        errors <- map["errors"]
        tokenError <- map["error_description"]
    }
    override var description: String {
        return "Code: \(String(describing: code)),"
        + " message: \(String(describing: message)),"
        + " requestId: \(String(describing: requestId))"
    }

}
