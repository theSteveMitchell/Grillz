//
//  ListViewController.swift
//  Grillz
//
//  Created by Steve Mitchell on 1/9/20.
//  Copyright © 2020 Steve Mitchell. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class ListViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager: CBCentralManager!
    let scanningDelay = 1.0
    var devices = [String: Device]()
    let cellIdentifier = "DeviceCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Found Devices"

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //register class
        //tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        manager = CBCentralManager(delegate: self, queue: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.keys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeviceTableViewCell
        
        // Configure the cell...
        if let device = deviceForIndexPath(indexPath){
            cell.deviceNameLabel?.text = device.name
            cell.deviceDescriptionLabel.text = "About $3.50"
            cell.deviceDistanceLabel.text = "\(device.rssi.description) dBm"
        }

        return cell
    }
    
    func deviceForIndexPath(_ indexPath: IndexPath) -> Device?{
        if indexPath.row > devices.keys.count{
            return nil
        }
        
        return Array(devices.values)[indexPath.row]
    
    }
    
    //override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //    return 200.6
    //}
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        if central.state == .poweredOn{
            manager.scanForPeripherals(withServices: nil, options: nil)
            
            print("started scan")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        didReadPeripheral(peripheral, rssi: RSSI)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        didReadPeripheral(peripheral, rssi: RSSI)
        //delay(scanningDelay){
            //peripheral.readRSSI()
        //}
    }
    
    func didReadPeripheral(_ peripheral: CBPeripheral, rssi: NSNumber){
        if let name = peripheral.name{
            devices[name] = Device(name: name, rssi: rssi as! Int)
            //print("found a peripheral")
            //print(peripheral.name)
            //puts(String(devices.keys.count))
        }
        tableView.reloadData()
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.readRSSI()
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

//func delay(_ delay:Double, closure:@escaping ()->()) {
  //  DispatchQueue.main.asyncAfter(
    //    deadline: <#T##DispatchTime#>.self + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
//}
