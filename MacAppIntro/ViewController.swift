//
//  ViewController.swift
//  MacAppIntro
//

import Cocoa
import CoreBluetooth

// TODO 
// - https://www.raywenderlich.com/118835/os-x-nstableview-tutorial
// - click on row action
// - connect to peripheral selected (disconnect the selectedPeripheral)

class ViewController: NSViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    

    // 
    var starterArray:[AnyObject] = NSLocale.preferredLanguages()
    

    //  BLE Stuff
    var myCentralManager = CBCentralManager()
    var peripherals:[CBPeripheral] = []
    var peripheralArray:[MotosurfPeripheral] = []
    var selectedPeripheral:CBPeripheral?

    
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
        tableView.setDelegate(self)
        tableView.setDataSource(self)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
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
    
        // save peripherals in array
        peripherals.append(peripheral)
        
        // create a MSNPeripheral with small data
        let p = MotosurfPeripheral(UUID: peripheral.identifier.UUIDString,
            RSSI: RSSI.intValue,
            name: peripheral.name,
            advertisementData: advertisementData)
        
        // add it to the TableDataSource
        peripheralArray.append(p)
        
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

extension ViewController: NSTableViewDataSource {

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return peripheralArray.count
    }
    
}

extension ViewController: NSTableViewDelegate {

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        let peripheral:MotosurfPeripheral? = peripheralArray[row]
        
        if peripheral == nil {
           return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = peripheral!.UUID
            cellIdentifier = "UUIDCell"
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(peripheral!.RSSI)
            cellIdentifier = "RSSICell"
        } else if tableColumn == tableView.tableColumns[2] {
            text = peripheral!.name == nil ? "" : peripheral!.name!
            cellIdentifier = "NameCell"
        } else if tableColumn == tableView.tableColumns[3] {
            text = String(peripheral!.advertisementData)
            cellIdentifier = "ServicesCell"
        }

        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
        
    }

}

