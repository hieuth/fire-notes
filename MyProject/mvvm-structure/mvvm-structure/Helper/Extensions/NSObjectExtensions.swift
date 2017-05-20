//
//  NSObjectExtensions.swift
//  AntClient
//
//  Created by Hoang on 2/14/17.
//  Copyright © 2017 Kins Solutions. All rights reserved.
//

import Foundation

extension NSObject {
    class func name() -> String {
        // get class name
        let path = NSStringFromClass(self)
        
        return path.components(separatedBy: ".").last ?? ""
    }
}
