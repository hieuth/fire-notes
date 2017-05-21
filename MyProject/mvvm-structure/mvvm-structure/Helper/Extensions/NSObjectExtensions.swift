//
//  NSObjectExtensions.swift
//
//  Created by Hieu huynh on 2/14/17.
//  All rights reserved.
//

import Foundation

extension NSObject {
    class func name() -> String {
        // get class name
        let path = NSStringFromClass(self)
        
        return path.components(separatedBy: ".").last ?? ""
    }
}
