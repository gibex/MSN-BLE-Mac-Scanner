//
//  MotosurfPeripheral.swift
//  MSN-BLE-Mac-Scanner
//
//  Created by doroftei gabriel on 17/08/16.
//  Copyright © 2016 yuryg. All rights reserved.
//

import Cocoa

class MotosurfPeripheral: NSObject {
    
    var UUID: String = ""
    var RSSI: Int32 = 0
    var name: String?
    var advertisementData:[String : AnyObject] = [:]
    
    init(UUID: String, RSSI: Int32, name: String?, advertisementData: [String : AnyObject]) {
        self.UUID = UUID
        self.RSSI = RSSI
        self.name = name
        self.advertisementData = advertisementData
    }
    
}
