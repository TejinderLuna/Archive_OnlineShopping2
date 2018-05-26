//
//  ViewController_ChangePassword.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/20/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

class ViewController_ChangePassword: UIViewController {

    @IBOutlet weak var savePasswordButton: UIButton!
    @IBOutlet weak var oldPasswordTextBox: UITextField!
    @IBOutlet weak var newPasswordTextBox: UITextField!
    @IBOutlet weak var repeatedNewPasswordTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        savePasswordButton.layer.cornerRadius = savePasswordButton.frame.height / 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func savePasswordTapped(_ sender: Any) {
        
        let uid = UserDefaults.standard.string(forKey: "userId")!
        let oldPassword = oldPasswordTextBox.text
        let newPassword = newPasswordTextBox.text
        let repeatedNewPassword = repeatedNewPasswordTextBox.text
        
                print("uid: ", uid, " ", oldPassword!, " ", newPassword!, " ", repeatedNewPassword!)
        
        // Check for empty fields
        if (oldPassword?.isEmpty)! || (newPassword?.isEmpty)! || (repeatedNewPassword?.isEmpty)! {
            displayMyAlertMessage("Alert", "All fields are required")
            return
        }
        
        // check if password match
        if newPassword != repeatedNewPassword {
            
            displayMyAlertMessage("Alert", "New passwords do not match")
            return
        }
        
        
        let myUrl = URL(string: "http://" + ViewController_Login.SERVER_IP + "/iosproject/updatePassword.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        let postString = "uid=\(uid)&oldPassword=\(oldPassword!)&newPassword=\(newPassword!)";
        
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
                    print("result: \(resultValue!)")
                    
                    var isUserRegistered:Bool = false
                    if resultValue == "Success" {
                        isUserRegistered = true
                        
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
                        
                        self.oldPasswordTextBox.text = ""
                        self.newPasswordTextBox.text = ""
                        self.repeatedNewPasswordTextBox.text = ""
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

    func displayMyAlertMessage(_ title:String, _ userMessage:String) {
        
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }

}
