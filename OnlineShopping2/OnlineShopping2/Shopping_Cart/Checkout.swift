//
//  Checkout.swift
//  OnlineShopping2
//
//  Created by Luna Tejinder on 4/21/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

class Checkout: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var paymentDropDown: UIPickerView!
    @IBOutlet weak var txtPaymentMethod: UITextField!
    
    @IBOutlet weak var txtCardNumber: UITextField!
    
    @IBOutlet weak var txtPickUp: UITextField!
    
    @IBOutlet weak var txtFullName: UITextField!
    
    @IBOutlet weak var txtContact: UITextField!
    var list = ["debit","credit","mastercard","cash on delivery"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.txtPaymentMethod.text = self.list[row]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtPaymentMethod {
            self.paymentDropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
    }
    
    @IBAction func payBynTapped(_ sender: UIButton) {
        let paymentMethod = txtPaymentMethod.text
        let cardNumber = txtCardNumber.text
        let pickUpAdd = txtPickUp.text
        let fullName = txtFullName.text
        let Contact = txtContact.text
        if ((paymentMethod?.isEmpty)! && (cardNumber?.isEmpty)! && (pickUpAdd?.isEmpty)! && (fullName?.isEmpty)! &&  (Contact?.isEmpty)!)
        {
            
            alertMessage("fill all the field first!")
            return
        }
        if ((paymentMethod?.isEmpty)!)
        {
            alertMessage("select Payment Method!")
            
            return
        }
        if ((cardNumber?.isEmpty)!)
        {
            alertMessage("Enter Card number!")
            
            return
        }
        if ((pickUpAdd?.isEmpty)!)
        {
            alertMessage("Enter address!")
            
            return
        }
        if ((fullName?.isEmpty)!)
        {
            alertMessage("enter Full Name!")
            return
        }
        if ((Contact?.isEmpty)!)
        {
            alertMessage("enter contact info!")
            return
        }
        if (!(paymentMethod?.isEmpty)! && !(cardNumber?.isEmpty)! && !(pickUpAdd?.isEmpty)! && !(fullName?.isEmpty)! &&  !(Contact?.isEmpty)!)
        {
            //alertMessage("saved")
            let userId:String? = UserDefaults.standard.string(forKey: "userId")
            if(shoppingCartItems.count > 0)
            {
                self.saveOrderDetails(_userId: userId!, _pickupaddress: pickUpAdd!)
            }
            else
            {
                alertMessage("Nothing in shopping cart!")
            }
        }
        
        
        
    }
    func alertMessage(_ userMessage:String) {
        
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    func saveOrderDetails(_userId:String,_pickupaddress:String){
        let myUrl = URL(string: "http://" + ViewController_Login.SERVER_IP + "/iosproject/saveOrderDetails.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        let postString = "userid=\(_userId)&pickupaddress=\(_pickupaddress)";
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // START - task definition
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error!).")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    let resultValue = parseJSON["status"] as? String
                    print("save ORDER DETAILS result: \(resultValue!)")
                    
                    var isUserRegistered:Bool = false
                    if resultValue == "Success" {
                        isUserRegistered = true
                        let userId:String? = UserDefaults.standard.string(forKey: "userId")
                        for item in shoppingCartItems{
                            //print(item.pid!, " ", item.des!, " ", item.details!, " ", item.price!, " ", item.quantity!, " ", item.shoppingQuantity!)
                            print("saving data........")
                            self.saveOrderProduct(_oid: userId!,_pid: String(item.pid!),_productQuantity: String(item.shoppingQuantity!))
                        }
                        shoppingCartItems.removeAll()
                    }
                    var messageToDisplay:String = parseJSON["message"] as! String
                    if !isUserRegistered {
                        messageToDisplay = parseJSON["message"] as! String
                    }
                    
                    DispatchQueue.main.async(execute: {
                        // Display result of registration
                        let myAlert = UIAlertController(title: "Info", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            action in
                            self.dismiss(animated: true, completion: nil)
                        }
                        myAlert.addAction(okAction)
                        self.present(myAlert, animated: true, completion: nil)
                    })
                    
                }
            } catch {
                print("Unexpected error: \(error).")
            }
            
        }
        //        // END - task definition
        //
        task.resume()
        
    }
    func saveOrderProduct(_oid:String,_pid:String,_productQuantity:String){
        let myUrl = URL(string: "http://" + ViewController_Login.SERVER_IP + "/iosproject/saveOrderProduct.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        let postString = "userid=\(_oid)&pid=\(_pid)&productquantity=\(_productQuantity)";
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // START - task definition
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error!).")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    let resultValue = parseJSON["status"] as? String
                    print("SAVE ORDER PRODUCT result: \(resultValue!)")
                    
                    var isUserRegistered:Bool = false
                    if resultValue == "Success" {
                        isUserRegistered = true
                    }
                    var messageToDisplay:String = parseJSON["message"] as! String
                    if !isUserRegistered {
                        messageToDisplay = parseJSON["message"] as! String
                        print(messageToDisplay)
                    }
                    
                    /*DispatchQueue.main.async(execute: {
                     // Display result of registration
                    let myAlert = UIAlertController(title: "Info", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert)
                     let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                     action in
                     self.dismiss(animated: true, completion: nil)
                     }
                     myAlert.addAction(okAction)
                     self.present(myAlert, animated: true, completion: nil)
                        print(messageToDisplay)
                     })*/
                    
                }
            } catch {
                print("Unexpected error: \(error).")
            }
            
        }
        //        // END - task definition
        //
        task.resume()
        
    }
    
    
}

