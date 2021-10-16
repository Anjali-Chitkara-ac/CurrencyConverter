//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Anjali Chitkara on 10/6/21.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    let baseURL = "https://free.currconv.com/api/v7/convert?q="
    let apiKey = "3f9f342eebc20f7fa1b9"
                
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var baseLbl: UITextField!
    
    @IBOutlet weak var targetLbl: UITextField!
    
    @IBOutlet weak var lblValue: UILabel!

    var pickerData = ["AED","AFN","ALL","AMD","ANG","AOA","ARS","AUD","AWG","AZN","BAM","BBD","BDT","BGN","BHD","BIF","BMD","BND","BOB","BRL","BSD","BTC","BTN","BWP","BYN","BYR","BZD","CAD","CDF","CHF","CLF","CLP","CNY","COP","CRC","CUC","CUP","CVE","CZK","DJF","DKK","DOP","DZD","EGP","ERN","ETB","EUR","FJD","FKP","GBP","GEL","GGP","GHS","GIP","GMD","GNF","GTQ","GYD","HKD","HNL","HRK","HTG","HUF","IDR","ILS","IMP","INR","IQD","IRR","ISK","JEP","JMD","JOD","KES","KGS","KHR","KMF","KPW","KRW","KWD","KYD","KZT","LAK","LBP","LKR","LRD","LSL","LVL","LYD","MAD","MDL","MGA","MKD","MMK","MNT","MOP","MRO","MUR","MVR","MWK","MXN","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD","OMR","PAB","PEN","PGK","PHP","PKR","PLN","PYG","QAR","RON","RSD","RUB","RWF","SAR","SBD","SCR","SDG","SEK","SGD","SHP","SLL","SOS","SRD","STD","SVC","SYP","SZL","THB","TJS","TMT","TND","TOP","TRY","TTD","TWD","TZS","UAH","UGX","USD","UYU","UZS","VEF","VND","VUV","WST","XAF","XAG","XCD","XDR","XOF","XPF","YER","ZAR","ZMK","ZMW","ZWL"]
    
    override func viewDidLoad() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        super.viewDidLoad()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedBase = pickerView.selectedRow(inComponent: 0)
        let selectedTarget = pickerView.selectedRow(inComponent: 1)
        let b = pickerData[selectedBase]
        let t = pickerData[selectedTarget]
        baseLbl.text = b
        targetLbl.text = t
    }

    
    @IBAction func getConvertedValue(_ sender: Any) {
                        
        if(baseLbl.text == "" || targetLbl.text == ""){
            return
        }
        
        let base : String = (baseLbl.text?.uppercased())!
        let target : String = (targetLbl.text?.uppercased())!
        
        getCurrencyValue(base, target);
        
    }
    
    func getCurrencyValue(_ base: String, _ target: String){
        
        let p1 = baseURL + base + "_" + target + "," + target
        let p2 = "_" + base + "&compact=ultra&apiKey=" + apiKey
        let url = p1 + p2
        
        SwiftSpinner.show("Converting the currency")
        
        AF.request(url).responseJSON { response in
            
            SwiftSpinner.hide()
            
            if (response.error != nil){//there was error
                print(response.error)
                return
            }
            
            //valid response
            print(url)
            let convertedValues = JSON(response.data!)
            
            if(convertedValues.isEmpty){
                self.lblValue.text = "Sorry, an error occurred!"
                return
            }

            let key = base + "_" + target
            
            let rate = convertedValues[key]
            print(rate)
            
            self.lblValue.text = " 1 \(base) = \(rate) \(target)"
            
        }
    }
    
}

