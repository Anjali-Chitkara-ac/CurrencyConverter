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

class ViewController: UIViewController {

    let baseURL = "https://free.currconv.com/api/v7/convert?q="
    let apiKey = "3f9f342eebc20f7fa1b9"
    
    @IBOutlet weak var baseCurrency: UITextField!
    
    @IBOutlet weak var targetCurrency: UITextField!
    
    @IBOutlet weak var lblValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getConvertedValue(_ sender: Any) {
        
        if(baseCurrency.text == "" || targetCurrency.text == ""){
            return
        }
        
        var p1 = baseURL + baseCurrency.text! + "_" + targetCurrency.text! + "," + targetCurrency.text!
        var p2 = "_" + baseCurrency.text! + "&compact=ultra&apiKey=" + apiKey
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
            
            //TODO handle empty convertedValues

            let key = self.baseCurrency.text! + "_" + self.targetCurrency.text!
            
            let rate = convertedValues[key]
            print(rate)
            
            self.lblValue.text = rate.stringValue
            
        }
        
    }
    
}

