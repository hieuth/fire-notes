//
//  AlertControllerExtension.swift
//
//  Created by Hieu Huynh on 4/13/17.
//  All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func showAlert( withTitle title: String? = nil, message: String?, from viewController: UIViewController, handler: UIAlertControllerCompletionBlock? = nil) {
        UIAlertController.showAlert(in: viewController, withTitle: title ?? "OOPS!", message: message, cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonTitles: nil, tap: handler)
    }

}
