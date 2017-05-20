//
//  AlertControllerExtension.swift
//  Teach With ANT
//
//  Created by Hieu Huynh on 4/13/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func showAlert( withTitle title: String? = nil, message: String?, from viewController: UIViewController, handler: UIAlertControllerCompletionBlock? = nil) {
        UIAlertController.showAlert(in: viewController, withTitle: title ?? "OOPS!", message: message, cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonTitles: nil, tap: handler)
    }

}
