//
//  RegisterViewController.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/8/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

class ViewController_Register: UIViewController {
    

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make button correr round
        registerButton.layer.cornerRadius = 10
        registerButton.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerButtonTapped(_ sender: Any) {
    
        let username = usernameTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text

//        print("user input: ", username!, userPassword!, userRepeatPassword!)
        
        // Check for empty fields
        if (username?.isEmpty)! || (userPassword?.isEmpty)! || (userRepeatPassword?.isEmpty)! {
            displayMyAlertMessage("Alert", "All fields are required")
            return
        }

        // check if password match
        if userPassword != userRepeatPassword {

            displayMyAlertMessage("Alert", "Password do not match")
            return
        }


        let myUrl = URL(string: "http://" + ViewController_Login.SERVER_IP + "/iosproject/userRegister.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"

        let postString = "username=\(username!)&password=\(userPassword!)";

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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
