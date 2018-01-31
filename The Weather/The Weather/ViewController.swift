//
//  ViewController.swift
//  The Weather
//
//  Created by Arun Ramakani on 1/31/18.
//  Copyright © 2018 Arun Ramakani. All rights reserved.
//

import UIKit
import MRProgress
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    
    var thePicker : UIPickerView!
    @IBOutlet weak var theTextfield: UITextField!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var theTextfield2: UITextField!

    public var myPickerData:[String:String] = [:]
    public var myPickerDataVal:[String] = []
    public var weatherData:[String:String] = [:]

    let picker2Data = [String](arrayLiteral: "1 Day Forecasts", "5 Days Forecasts", "10 Days Forecasts", "15 Days Forecasts")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       let image : UIImage = UIImage(named: "logo2.png")!
       let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
       imageView.contentMode = .scaleAspectFit
       imageView.image = image
       self.navigationItem.titleView = imageView
        
       theTextfield.inputView = thePicker
       theTextfield.delegate = self
        
       theTextfield2.inputView = thePicker
       theTextfield2.delegate = self
        
        MRProgressOverlayView.showOverlayAdded(to: self.view, animated: true)
        Alamofire.request("https://dataservice.accuweather.com/locations/v1/topcities/150?apikey=W529m30fXQi6BF2N9TdCoRk4xOcEbupc").responseData { (resData) -> Void in
            let swiftyJsonVar = JSON(resData.result.value!)
            print(swiftyJsonVar)
            
            for subJson in swiftyJsonVar.arrayValue {
                self.myPickerData[subJson["Key"].string!] = subJson["LocalizedName"].string
            }
    
            self.myPickerDataVal =  Array(self.myPickerData.values)
            MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
        }
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 10) {
            return myPickerDataVal.count
        } else {
            return picker2Data.count
        }
        
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if(pickerView.tag == 10) {
            return myPickerDataVal[row]
        } else {
            return picker2Data[row]
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
        if(pickerView.tag == 10) {
            theTextfield.text = myPickerDataVal[row]
        } else {
            theTextfield2.text = picker2Data[row]
        }
        
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(textField)
    }
    
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.thePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.thePicker.delegate = self
        self.thePicker.dataSource = self
        self.thePicker.backgroundColor = UIColor.white
        textField.inputView = self.thePicker
        
        if(textField == theTextfield){
            thePicker.tag = 10
        } else {
            thePicker.tag = 11
        }
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    @objc
    func doneClick() {
        theTextfield.resignFirstResponder()
        theTextfield2.resignFirstResponder()
    }
    @objc
    func cancelClick() {
        theTextfield.resignFirstResponder()
        theTextfield2.resignFirstResponder()
    }
    
    @IBAction func donePress(sender: UIButton) {
        MRProgressOverlayView.showOverlayAdded(to: self.view, animated: true)
        
        var count = 0;
        var urlPart : String!
        let type = picker2Data.index(of: theTextfield2.text!)
        if(type == 0) {
            count = 1
            urlPart = "1day"
        } else if(type == 1){
            count = 5
           urlPart = "5day"
        }else if(type == 2){
            count = 10
            urlPart = "10day"
        } else if(type == 3){
            count = 15
            urlPart = "15day"
        }
        var url : String = "https://dataservice.accuweather.com/forecasts/v1/daily/{type}/28143?apikey=W529m30fXQi6BF2N9TdCoRk4xOcEbupc"
        url = url.replacingOccurrences(of: "{type}", with: urlPart)
        
        Alamofire.request(url).responseData { (resData) -> Void in
            let swiftyJsonVar = JSON(resData.result.value!)
            print(swiftyJsonVar)
            
            for subJson in swiftyJsonVar["DailyForecasts"].arrayValue {
                self.weatherData[subJson["Date"].string!] = String(subJson["Temperature"]["Minimum"]["Value"].int!) 
            }

            MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
            self.nextView(count: count)
            print("ccc")
            print(self.weatherData)
        }
    }
    
   
    
    func nextView(count: Int) {
        
        if theTextfield.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Alert", message: "Please select a city.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if theTextfield2.text?.isEmpty ?? true {
            let alert = UIAlertController(title: "Alert", message: "Please select a forcast type.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
            
            nextVC.count = count
            nextVC.weatherData = weatherData
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }


}

