//
//  ViewController.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/6/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

class ViewController_Login: UIViewController {
    
    open static let SERVER_IP:String = "13.58.145.234"

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make button correr round
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            
        } else {
            print("Portrait")
            logoImageView.isHidden = false
        }
    }
    

    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let username = usernameTextField.text
        let userPassword = userPasswordTextField.text
        
        
        if (username?.isEmpty)! || (userPassword?.isEmpty)! {
            displayMyAlertMessage("Alert", "All fields are required")
            return
        }
        
        let myUrl = URL(string: "http://" + ViewController_Login.SERVER_IP + "/iosproject/userLogin.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        let postString = "username=\(username!)&password=\(userPassword!)";
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        // START - task definition
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error!)")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    let resultValue = parseJSON["status"] as? String
//                    let messageValue = parseJSON["message"] as? String
//                    print("result: \(resultValue!) message: \(messageValue!)")
                    
                    if resultValue == "Success" {
                        // set isUserLoggedIn true
                        // no need to ask for user to input username and password if user already logged in
                        let userIdValue = parseJSON["id"] as? String
                        
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(userIdValue, forKey: "userId")
                        UserDefaults.standard.synchronize()
                        

                        let mainTabBarController:TabBarController_Main = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBarController") as! TabBarController_Main
                        
                        DispatchQueue.main.async(execute: {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = mainTabBarController
                            appDelegate.window?.makeKeyAndVisible()
                        })
                        
                    } else {
                        // CalldisplayMyAlertMessage must be in the main thread
                        DispatchQueue.main.async(execute: {
                            // Clear password field, but keep username field
                            self.userPasswordTextField.text = ""
                            self.displayMyAlertMessage("Alert", "Login failed")
                        })
                        
                    }
                    
                }
            } catch {
                print("Unexpected error: \(error).")
            }
            
        }
        // END - task definition
        task.resume()
        
    }
    
    func displayMyAlertMessage(_ title:String, _ userMessage:String) {
        
        let myAlert = UIAlertController(title: title, message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
}

