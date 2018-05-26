//
//  OrderDetailsViewController.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/13/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit



class ViewController_OrderDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var productDescriptionArray = [String]()
    private var productPriceArray = [String]()
    private var productQuantityArray = [String]()
    private var productImageNameArray = [String]()
    
    @IBOutlet weak var oidLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var orderDetailsTableView: UITableView!
    @IBOutlet weak var viewPickUpSpotOnMapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oidLabel.text = "Order ID: " + orderIdArray[orderIndex]
        orderDateLabel.text = "Order Date: " + orderDateArray[orderIndex]
        pickupAddressLabel.text = pickupAddressArray[orderIndex]
        
        viewPickUpSpotOnMapButton.layer.cornerRadius = viewPickUpSpotOnMapButton.frame.height / 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let userId:String = UserDefaults.standard.string(forKey: "userId")!
        let orderId:String = orderIdArray[orderIndex]
//        print("userid: ", userId, "orderid: ", orderId)
        
        oidLabel.text = "Order ID: " + orderIdArray[orderIndex]
        orderDateLabel.text = "Order Date: " + orderDateArray[orderIndex]
        pickupAddressLabel.text = pickupAddressArray[orderIndex]
        
        clearAndReloadOrderDetailsTableView()
        
        getOrderDetailsList(userId: userId, orderId: orderId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDescriptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetailsCell", for: indexPath) as! TableViewCell_OrderDetails
        
        if productDescriptionArray.count > 0 {
            
            cell.productDescriptionLabel.text = productDescriptionArray[indexPath.row]
            cell.productPriceLabel.text = "Price: " + currencyFormatter.string(from: Double(productPriceArray[indexPath.row])! as NSNumber)! + "CAD"
            cell.productQuantityLabel.text = "Qty: " + String(productQuantityArray[indexPath.row])
            cell.productImageView.image = UIImage(named:productImageNameArray[indexPath.row])
            cell.productImageView.layer.cornerRadius = cell.productImageView.frame.height / 10
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func clearAndReloadOrderDetailsTableView() {
        // because in func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        // use count of productDescriptionArray as return, clear it in order to reload table view
        productDescriptionArray.removeAll()
        orderDetailsTableView.reloadData()
    }
    
    func getOrderDetailsList(userId:String, orderId:String) {
        
        let myUrl = URL(string: "http://" + ViewController_Login.SERVER_IP + "/iosproject/getOrderDetails.php")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        
        let postString = "uid=\(userId)&&oid=\(orderId)";
        
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
                        
                        let orderHistoryList = parseJSON["orderDetailsList"] as? NSArray
                        
                        for (_, order) in orderHistoryList!.enumerated() {
                            let productInDict = order as! Dictionary<String, String>
                            //                            print(index, " ", productInDict["description"]!)
                            
                            self.productDescriptionArray.append(productInDict["description"]!)
                            self.productPriceArray.append(productInDict["price"]!)
                            self.productQuantityArray.append(productInDict["productquantity"]!)
                            self.productImageNameArray.append(productInDict["imagename"]!)
                        }
                        
//                                                print(self.productDescriptionArray.count)
                        
                        DispatchQueue.main.async(execute: {
                            self.orderDetailsTableView.reloadData();
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
