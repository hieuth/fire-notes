//
//  HHPaddingTextField.swift
//  FireNotes
//
//  Created by Hieu Huynh on 5/20/17.
//  All rights reserved.
//

import UIKit

class HHPaddingTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
}
