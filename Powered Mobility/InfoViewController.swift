import UIKit
import Foundation
import CoreBluetooth

class InfoViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var connectedSwitch: UISwitch!
    var data : [String:String] = ["Battery" : "NA", "Max Speed" : "2", "Bluetooth" : "NA", "Front Sensor" : "NA", "Back Sensor" : "NA", "Motor Left" :"OK", "Motor Right" : "OK", "Forward" : "NA", "Backward" : "NA", "Left" : "NA", "Right" : "NA"]
    
    var switches : [String : String] = ["8" : "Second Yellow", "9" : "First Yellow", "10" : "Red", "12" : "Blue"]
    var peripheralManager: CBPeripheralManager?
    @IBOutlet weak var basetabke: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basetabke.delegate = self
        basetabke.dataSource = self
        basetabke.reloadData()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (connected){
            connectedSwitch.setOn(true,animated: true)
        } else{
            connectedSwitch.setOn(false,animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlueCell") as! PeripheralTableViewCell
        var string = Array(data.keys)
        cell.peripheralLabel.text = string[indexPath.row]
        cell.rssiLabel.text = data[string[indexPath.row]]
        print (string[indexPath.row])
        return cell
    }
    
    
    @IBAction func refreshAction(_ sender: Any) {
       writeValue(data: "c;")
       if (serial_value != ""){
        print(serial_value)
        var arr = serial_value.components(separatedBy: "|")
            print (arr.count)
            if (arr.count == 7){
                data["Battery"] = arr[0]
                data["Front Sensor"] = arr[1]
                data["Back Sensor"] = arr[2]
                data["Forward"] = switches[arr[3]]
                data["Backward"] = switches[arr[4]]
                data["Left"] = switches[arr[5]]
                data["Right"] = switches[arr[6]]
                
                if (connected){
                    data["Bluetooth"] = "Connected"
                } else {
                    data["Bluetooth"] = "Not Connected"
                }
                basetabke.reloadData()
            }
        }
    }
    
    func writeValue(data: String){
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        //change the "data" to valueString
        if let blePeripheral = blePeripheral{
            if let txCharacteristic = txCharacteristic {
                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withoutResponse)
            }
        }
    }
    
    func writeCharacteristic(val: Int8){
        var val = val
        let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
        blePeripheral!.writeValue(ns as Data, for: txCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            return
        }
        print("Peripheral manager is running")
    }
    
    //Check when someone subscribe to our characteristic, start sending the data
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Device subscribe to characteristic")
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print ("????")
            print("\(error)")
            return
        }
    }
}
