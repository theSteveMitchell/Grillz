//
//  Device.swift
//  Grillz
//
//  Created by Steve Mitchell on 1/9/20.
//  Copyright © 2020 Steve Mitchell. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class Device: NSObject {
    
    var name: String = ""
    var rssi: Int = 0
    var advertisement: [String : Any] = [:]
    var peripheral: CBPeripheral?
    
    init(name: String, rssi: Int, advertisement: [String : Any], peripheral: CBPeripheral) {
        super.init()
        
        self.name = name
        self.rssi = rssi
        self.advertisement = advertisement
        self.peripheral = peripheral
        
        if let power = advertisement["kCBAdvDataTxPowerLevel"] {
            print("power is \(power) and rssi is \(rssi)")
        }
        
    }
}
