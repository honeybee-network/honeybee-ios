//
//  URFireBaseManager.swift
//  ureport
//
//  Created by Daniel Amaral on 17/08/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit
import Firebase

class URFireBaseManager: NSObject {
    
//    static let Properties = "Key"
//    static let Path = "https://honeybee-dev.firebaseio.com"
//    static let GCM_DEBUG_MODE = true
    
    static let GCM_DEBUG_MODE = false
    static let Path = "https://honeybee-dev.firebaseio.com"
    static let Properties = "Key-debug"
    
    static let Reference = Firebase(url: Path)
    
    static func sharedInstance() -> Firebase {
        return Reference
    }
    
}
