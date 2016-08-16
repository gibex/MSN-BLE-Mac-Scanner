//
//  ViewController.swift
//  MacAppIntro
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController, CBCentralManagerDelegate, CBPeripheralDelegate, NSTableViewDataSource {
    

    // 
    var starterArray:[AnyObject] = NSLocale.preferredLanguages()
    

    //  BLE Stuff
    var myCentralManager = CBCentralManager()
    var peripheralArray = [CBPeripheral]()

    var fullPeripheralArray:[(String, String, String, String)] = []
    var cleanAndSortedArray: [(String, String, String, String)] = []

    
    //  UI Stuff
    @IBOutlet weak var inputText: NSTextField!
    @IBOutlet weak var outputText: NSTextField!
    @IBOutlet weak var labelStatus: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    
    @IBAction func scanButtonCell(sender: NSButtonCell) {
        
        if sender.state == 1 {
            updateStatusLabel("Scannning")
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil )
        } else {
            updateStatusLabel("Not Scanning")
            myCentralManager.stopScan()
        }
    }

    @IBAction func refreshButton(sender: NSButtonCell) {
        if sender.state == 1{
            updateStatusLabel("Scannning")
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil )
        } else {
            updateStatusLabel("Not Scanning")
            myCentralManager.stopScan()
        
            cleanAndSortedArray.removeAll()
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    // NSTableView
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return cleanAndSortedArray.count
    }
    
    
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {

        if tableColumn?.identifier == "first" {
            let myString = cleanAndSortedArray[row].0
            return myString
        }
        if tableColumn?.identifier == "second"{
            let myString = "\(cleanAndSortedArray[row].1)"
            return myString
        }
      
        if tableColumn?.identifier == "third"{
            let myString = "\(cleanAndSortedArray[row].2)"
            return myString

        }
    
        if tableColumn?.identifier == "forth"{
            let myString = "\(cleanAndSortedArray[row].3)"
            return myString
            
        }
            
            
        else{
            let myString = "\(cleanAndSortedArray[row].3)"
            return myString
        }
    }
    
    //MARK  CoreBluetooth Stuff
    
    
    
    // Put CentralManager in the main queue
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myCentralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
        
    }
    

    

    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        switch central.state{
        case .PoweredOn:
            updateStatusLabel("poweredOn")
            
            
        case .PoweredOff:
            updateStatusLabel("Central State PoweredOFF")
            
        case .Resetting:
            updateStatusLabel("Central State Resetting")
            
        case .Unauthorized:
            updateStatusLabel("Central State Unauthorized")
            
        case .Unknown:
            updateStatusLabel("Central State Unknown")
            
        case .Unsupported:
            updateStatusLabel("Central State Unsupported")
            
        }
    }
    
    func updateStatusLabel(passedString: String ){
        labelStatus.stringValue = passedString
    }


    func updateOutputText(passedString: String ){
       outputText.stringValue  = passedString + "\r" + outputText.stringValue
    }

    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    
            let myUUIDString = peripheral.identifier.UUIDString
            let myRSSIString = String(RSSI.intValue)
            let myNameString = peripheral.name
            let advertString = "\(advertisementData)"
        
//        var myAdvertisedServices = peripheral.services
      //  var myServices1 = peripheral.services
      //  var serviceString = " service string "
//        var myArray = advertisementData
     //   serviceString = "service: \(myArray)"
     //   println(serviceString)
     //   updateOutputText("service:" + serviceString)
    
            updateOutputText("\r")
            updateOutputText("UUID: " + myUUIDString)
            updateOutputText("RSSI: " + myRSSIString)
            updateOutputText("Name:  \(myNameString)")
            updateOutputText("advertString: " + advertString)

        
        
            let myTuple = (myUUIDString, myRSSIString, "\(myNameString)", advertString )
        
            cleanAndSortedArray.append(myTuple)
        
            tableView.reloadData()
        
        }

}

