//
//  UIViewExtensions.swift
//
//  Created by Hieu Huynh on 2/14/17.
//  Copyright © 2017 Kins Solutions. All rights reserved.
//

import UIKit

extension UIView {
    // load view from nib
    class func view<T: UIView>(withNibName nibName: String?, owner: AnyObject? = nil) -> T? {
        // nib name
        let name = nibName ?? self.name()
        // load view from nib
        return Bundle.main.loadNibNamed(name, owner: owner, options: nil)?.first as? T
    }
}
