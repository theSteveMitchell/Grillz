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

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
         if central.state == .poweredOn{
            device.delegate = self
            manager.connect(device, options: nil)
               //if #available(iOS 13.0, *) {
                   //manager.registerForConnectionEvents(options: nil)
               //}
               print("started connect")
               //let known = manager.retrievePeripherals(withIdentifiers: nil)
         }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral){
        print("succeeded in connecting")
        let dis_service: CBUUID = CBUUID.init(string: "180A")
        // https://www.bluetooth.com/specifications/gatt/services/
        peripheral.delegate = self
        peripheral.discoverServices([dis_service]) // callback to ...didDiscoverServices
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
    
    // End of the fucking line.  This should be called for each characteristic on each service, subservice, sub-subservice, etc.
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
        //print("value for characteristic: \(characteristic.value!)")
        if let string = String(bytes: characteristic.value!, encoding: .utf8) {
            print("value for characteristic \(characteristic.uuid): \(string)")
            device_info["\(characteristic.uuid)"] = string
        } else {
            print("value for characteristic \(characteristic.uuid): not a string")
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //manager = CBCentralManager(delegate: self, queue: nil)
        manager.delegate = self
        
        manager.connect(device, options: nil)
        //if #available(iOS 13.0, *) {
            //manager.registerForConnectionEvents(options: nil)
        //}
        print("started connect")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return device_info.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
