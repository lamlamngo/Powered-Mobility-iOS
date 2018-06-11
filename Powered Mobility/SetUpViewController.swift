//
//  SetUpViewController.swift
//  Powered Mobility
//
//  Created by Lam Ngo on 5/10/18.
//  Copyright © 2018 Lam Ngo. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class SetUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CBPeripheralManagerDelegate{
    
    @IBOutlet weak var connectSwitch: UISwitch!
    @IBOutlet weak var maxspeed: UISegmentedControl!
    @IBOutlet weak var safemodeswitch: UISwitch!
    @IBOutlet weak var input: UISegmentedControl!
    @IBOutlet weak var fourthVal: UILabel!
    @IBOutlet weak var thirdVal: UILabel!
    @IBOutlet weak var secondVal: UILabel!
    @IBOutlet weak var firstVal: UILabel!
    @IBOutlet weak var fourthSlider: UISlider!
    @IBOutlet weak var thirdSlider: UISlider!
    @IBOutlet weak var secondSlider: UISlider!
    @IBOutlet weak var firstSlider: UISlider!
    @IBOutlet weak var safemode_slider: UISlider!
    @IBOutlet weak var fourthPickerView: UIPickerView!
    @IBOutlet weak var thirdPickerView: UIPickerView!
    @IBOutlet weak var secondPickerView: UIPickerView!
    @IBOutlet weak var firstPickerView: UIPickerView!
    @IBOutlet weak var mode: UISegmentedControl!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var safemode_value: UILabel!
    
    var pickerData : [String] = ["forward", "backward", "left", "right"]
    var maxSpeed : Int = 1
    var modes : Int = 0
    var first : String = ""
    var second : String = ""
    var third : String = ""
    var fourth : String = ""
    
    var first_slider : String = "0"
    var second_slider : String = "0"
    var third_slider : String = "0"
    var fourth_slider : String = "0"
    var safemode_distance : String = "80"
    
    var peripheralManager: CBPeripheralManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        firstPickerView.delegate = self
        firstPickerView.dataSource = self

        secondPickerView.delegate = self
        secondPickerView.dataSource = self

        fourthPickerView.delegate = self
        fourthPickerView.dataSource = self

        thirdPickerView.delegate = self
        thirdPickerView.dataSource = self
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    
    @IBAction func speedChanged(_ sender: Any) {
        switch maxspeed.selectedSegmentIndex
        {
        case 0: maxSpeed = 1
                break
        case 1: maxSpeed = 2
                break
        case 2: maxSpeed = 3
                break
        default:
            break
        }
    }
    
    @IBAction func modeChanged(_ sender: Any) {
        switch self.mode.selectedSegmentIndex
        {
            case 0: modes = 0
                break
            case 1: modes = 1
                break
            case 2: modes = 2
                break
            default:
                break
        }
    }
    
    @IBAction func inputChanged(_ sender: Any) {
        switch self.input.selectedSegmentIndex
        {
            case 0: firstPickerView.isHidden = false
                    secondPickerView.isHidden = true
                    thirdPickerView.isHidden = true
                    fourthPickerView.isHidden = true
                    break
            case 1:firstPickerView.isHidden = false
            secondPickerView.isHidden = false
            thirdPickerView.isHidden = true
            fourthPickerView.isHidden = true
                    break
        case 2:firstPickerView.isHidden = false
        secondPickerView.isHidden = false
        thirdPickerView.isHidden = false
        fourthPickerView.isHidden = true
                    break
        case 3: firstPickerView.isHidden = false
        secondPickerView.isHidden = false
        thirdPickerView.isHidden = false
        fourthPickerView.isHidden = false
            default:
                break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if (connected){
            connectSwitch.setOn(true,animated: true)
        } else{
            connectSwitch.setOn(false,animated: true)
        }
        
        switch self.input.selectedSegmentIndex
        {
        case 0: firstPickerView.isHidden = false
        secondPickerView.isHidden = true
        thirdPickerView.isHidden = true
        fourthPickerView.isHidden = true
            break
        case 1:firstPickerView.isHidden = false
        secondPickerView.isHidden = false
        thirdPickerView.isHidden = true
        fourthPickerView.isHidden = true
            break
        case 2:firstPickerView.isHidden = false
        secondPickerView.isHidden = false
        thirdPickerView.isHidden = false
        fourthPickerView.isHidden = true
            break
        case 3: firstPickerView.isHidden = false
        secondPickerView.isHidden = false
        thirdPickerView.isHidden = false
        fourthPickerView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func secondChanged(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        secondVal.text = "\(currentValue)"
        second_slider = String(currentValue)
    }
    
    @IBAction func firstChanged(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        firstVal.text = "\(currentValue)"
        first_slider = String(currentValue)
    }
    
    
    @IBAction func thirdChanged(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        thirdVal.text = "\(currentValue)"
        third_slider = String(currentValue)
    }
    
    
    @IBAction func fourthChanged(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        fourthVal.text = "\(currentValue)"
        fourth_slider = String(currentValue)
    }
    
    
    @IBAction func safemode_changed(_ sender: UISlider) {
        var current_value = Int(sender.value) * 10
        safemode_value.text = "\(current_value)"
        safemode_distance = String(current_value)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
            case firstPickerView:   first = pickerData[row]
                                    print (pickerData[row])
                                    break
        case secondPickerView:   second = pickerData[row]
                                    print (second)
            break
        case thirdPickerView:   third = pickerData[row]
            break
        case fourthPickerView:   fourth = pickerData[row]
            break
        default: break
        }
    }
    
    
    @IBAction func applyPressed(_ sender: UIButton) {
        var sm : String = "0"
        if (safemodeswitch.isOn){
            sm = "1"
        } else{
            sm = "0"
        }
        var res : String = "\(maxSpeed)" + "\(modes)" + sm + "\(Int (input.selectedSegmentIndex) + 1)"
        
        print (res)
        switch self.input.selectedSegmentIndex
        {
        case 0: res += String(first[first.startIndex]) + first_slider
                res += first_slider
            break
        case 1:res += String(first[first.startIndex]) + first_slider + String(second[second.startIndex]) + second_slider
            break
        case 2: res += String(first[first.startIndex]) + first_slider + String(second[second.startIndex]) + second_slider + String(third[third.startIndex]) + third_slider
            break
        case 3: res += String(first[first.startIndex]) + first_slider + String(second[second.startIndex]) + second_slider +  String(third[third.startIndex]) + third_slider +  String(fourth[fourth.startIndex]) + fourth_slider
            break
        default:
            break
        }
        
        switch Int(safemode_distance){
        case 80: res += String(0)
                    break
        case 90: res += String(1)
                    break
        case 100: res += String(2)
                    break
        case 110: res += String(3)
                    break
        case 120: res += String(4)
                    break
        case 130: res += String(5)
            break
        case 140: res += String(6)
            break
        case 150: res += String(7)
            break
        default:
            break
        }

        res += ";"
        
        print (res)
        writeValue(data: res)
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
