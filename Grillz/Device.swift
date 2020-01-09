//
//  Device.swift
//  Grillz
//
//  Created by Steve Mitchell on 1/9/20.
//  Copyright © 2020 Steve Mitchell. All rights reserved.
//

import UIKit

class Device: NSObject {
    
    var name: String = ""
    var rssi: Int = 0
    
    init(name: String, rssi: Int) {
        super.init()
        
        self.name = name
        self.rssi = rssi
    }

}
