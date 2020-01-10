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

        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        manager = CBCentralManager(delegate: self, queue: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDeviceDetails" {

            let deviceViewController = segue.destination
                 as! DeviceViewController

            let myIndexPath = self.tableView.indexPathForSelectedRow!
            let row = myIndexPath.row
            deviceViewController.deviceName = Array(devices.values)[row].name
            }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        if central.state == .poweredOn{
            manager.scanForPeripherals(withServices: nil, options: nil)
            //if #available(iOS 13.0, *) {
                //manager.registerForConnectionEvents(options: nil)
            //}
            print("started scan")
            //let known = manager.retrievePeripherals(withIdentifiers: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        didReadPeripheral(peripheral, rssi: RSSI, advertisement: advertisementData)
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let name = peripheral.name{
            devices[name]?.rssi = RSSI as! Int
        }
        tableView.reloadData()
        
        delay(scanningDelay){
            peripheral.readRSSI()
        }
        
    }
    
    func didReadPeripheral(_ peripheral: CBPeripheral, rssi: NSNumber, advertisement: [String : Any]){
        if let name = peripheral.name{
            devices[name] = Device(name: name, rssi: rssi as! Int, advertisement: advertisement)
        }
        tableView.reloadData()
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.readRSSI()
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: .now() + delay, execute: closure)
}
