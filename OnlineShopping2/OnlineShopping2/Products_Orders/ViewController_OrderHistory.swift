//
//  OrderHistoryViewController.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/8/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

var orderIdArray = [String]()
var orderDateArray = [String]()
var pickupAddressArray = [String]()
var orderIndex:Int = -1

class ViewController_OrderHistory: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var username:String = ""
    var userId:String = ""
    
    @IBOutlet weak var orderHistoryTableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {

        print("--- hithit ---")
        
        clearAndReloadOrderHistoryTableView()
        getOrderHistoryList(userId: userId)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username = UserDefaults.standard.string(forKey: "username")!
        userId = UserDefaults.standard.string(forKey: "userId")!
        //        usernameLabel.text = "Welcome, " + username! + " id: " + userId!

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        print("orderIdArray.count: ", orderIdArray.count)
        return (orderIdArray.count)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderIndex = indexPath.row
        performSegue(withIdentifier: "viewOrderDetailsSegue", sender: self)
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! TableViewCell_OrderHistory
        
        if orderIdArray.count > 0 {
            cell.oidLabel.text = "Order ID: " + orderIdArray[indexPath.row]
            cell.orderDateLabel.text = "Order Date: " + orderDateArray[indexPath.row]
            cell.pickUpAddressLabel.text = pickupAddressArray[indexPath.row]
        }
        
        return cell
    }
    
    func clearAndReloadOrderHistoryTableView() {
        // because in func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        // use count of orderIdArray as return, clear it in order to reload table view
        orderIdArray.removeAll()
        orderHistoryTableView.reloadData()
    }
    
    func getOrderHistoryList(userId:String) {
        
        orderIdArray.removeAll()
        orderDateArray.removeAll()
        pickupAddressArray.removeAll()
        
        let myUrl = URL(string: "http://" + ViewController_Login.SERVER_IP + "/iosproject/getOrderHistory.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        let postString = "uid=\(userId)";
        
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
                    //                    print("resultValue: " + resultValue!)
                    
                    
                    if resultValue == "Success" {
                        
                        let orderHistoryList = parseJSON["orderHistoryList"] as? NSArray
                        
                        for (_, order) in orderHistoryList!.enumerated() {
                            let orderInDict = order as! Dictionary<String, String>
//                            print(index, " ", orderInDict["oid"]!)
                            
                            orderIdArray.append(orderInDict["oid"]!)
                            orderDateArray.append(orderInDict["orderdate"]!)
                            pickupAddressArray.append(orderInDict["pickupaddress"]!)
                        }
                        
                        //                        print(orderIdArray)
                        
                        DispatchQueue.main.async(execute: {
                            self.orderHistoryTableView.reloadData();
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
    
    
}
