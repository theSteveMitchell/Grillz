//
//  DeviceViewController.swift
//  Grillz
//
//  Created by Steve Mitchell on 1/10/20.
//  Copyright © 2020 Steve Mitchell. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class DeviceViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager: CBCentralManager!
    var device: CBPeripheral!
    var device_info: [String: String] = [:]
    let DIS_SERVICE: CBUUID = CBUUID.init(string: "180A")
    //Device Information Service is the one we want.  This is a special reserved Bluetooth service ID defined here:
    // https://www.bluetooth.com/specifications/gatt/services/
    // Note - the short-form string "180A" creates a CBUUID Object with a UUID that is a product of this string, and the standards Bluetooth UUID Mask.
    // The Bluetooth Base/Mask is 00000000-0000-1000-8000-00805F9B34FB
    // And for "standard"/public services/characteristics, the spefic UUID is masked to the first 8 bytes of that UUID.
    // So, "180A" denotes bytes 0x180A, which is a shorthand for 0x0000180A.  Apply this to the first 8 bytes of the Bluetooth UUID,
    // result: 0000180A-0000-1000-8000-00805F9B34FB

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
         if central.state == .poweredOn{
            device.delegate = self
            manager.connect(device, options: nil)
            
            print("started connect")
         }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral){
        print("succeeded in connecting")
        // https://www.bluetooth.com/specifications/gatt/services/
        peripheral.delegate = self
        peripheral.discoverServices([DIS_SERVICE]) // callback to ...didDiscoverServices
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        
        for service in peripheral.services! {
            //peripheral.discoverIncludedServices(nil, for: service) //callback to ..didDiscoverIncludedServicesFor
            peripheral.discoverCharacteristics(nil, for: service) //callback to ..didDiscoverCharacteristic
        }
    }
    
    // This potentially could be called recursively, since service heirarchies can be several levels deep.
    /*
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?){
        for subservice in service.includedServices! {
            peripheral.discoverIncludedServices(nil, for: subservice) //callback to ..didDiscoverIncludedServicesFor
            peripheral.discoverCharacteristics(nil, for: subservice) //callback to ..didDiscoverCharacteristic
        }
    }
    */
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        for characteristic in service.characteristics! {
            //peripheral.discoverDescriptors(for: characteristic)
            peripheral.readValue(for: characteristic)
        }
        print("all characteristics found, possibly")

    }
    
    // This should be called for each characteristic on each service, subservice, sub-subservice, etc.
    /*
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?){
        for descriptor in characteristic.descriptors! {
            if let value = descriptor.value {
                print("Descriptor: \(value)")
            }
            
        }
        print("all descriptors found, possibly")
        
    }
    */
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        if let string = String(bytes: characteristic.value!, encoding: .utf8) {
            // print("value for characteristic \(characteristic.uuid): \(string)")
            // Note, the CBUUID class has a magic way of converting the "reserved" characteristic UUIDS to usable strings
            // i.e.e the UUID 0x2A29 is converted to "Manufacturer Name String".  These characteristic identifiers are documented here:
            //  https://www.bluetooth.com/specifications/gatt/characteristics/
            //But I don't yet understand how that converstion is actually made in the UUID class.
            device_info["\(characteristic.uuid)"] = string
            
        }
        
        // weird hack right now to add fake price data
        if device_info.count == 1{
            device_info["Pricetag (AOL Search)"] = "$\(Int.random(in: 1...2100)).\(Int.random(in: 1...99))"
        }
        
        tableView.reloadData()
    }
    
    
    func centralManager(_ central: CBCentralManager,
    didFailToConnect peripheral: CBPeripheral,
    error: Error?){
        print("failed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = device.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        manager.delegate = self
        
        manager.connect(device, options: nil)
        print("started connect")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return device_info.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceDetailCell", for: indexPath)

        cell.textLabel?.text = Array(device_info.values)[indexPath.section]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(device_info.keys)[section]
    }
}
