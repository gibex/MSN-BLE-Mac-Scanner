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

    var peripheralArray:[MotosurfPeripheral] = []

    
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
        
            peripheralArray.removeAll()
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
        return peripheralArray.count
    }
    
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        
        if tableColumn?.identifier == "first" {
            print(tableColumn?.identifier)
            return peripheralArray[row].UUID
        }
        if tableColumn?.identifier == "second"{
            return String(peripheralArray[row].RSSI)
        }
      
        if tableColumn?.identifier == "third"{
            return peripheralArray[row].name

        }
    
        if tableColumn?.identifier == "forth"{
            return "\(peripheralArray[row].advertisementData)"
            
        }
            
            
        else{
            return "\(peripheralArray[row].advertisementData)"
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
    
        let p = MotosurfPeripheral(UUID: peripheral.identifier.UUIDString,
            RSSI: RSSI.intValue,
            name: peripheral.name,
            advertisementData: advertisementData)
        
        peripheralArray.append(p)
        
//        var myAdvertisedServices = peripheral.services
      //  var myServices1 = peripheral.services
      //  var serviceString = " service string "
//        var myArray = advertisementData
     //   serviceString = "service: \(myArray)"
     //   println(serviceString)
     //   updateOutputText("service:" + serviceString)
    
            updateLog(p)
            tableView.reloadData()
        
        }
    
    func updateLog(p: MotosurfPeripheral)
    {
        updateOutputText("\r")
        updateOutputText("UUID: " + p.UUID)
        updateOutputText("RSSI: " + String(p.RSSI))
        updateOutputText("Name:  \(p.name)")
        updateOutputText("advertString: \(p.advertisementData)")
    
    }

}

