//
//  ShoppingCartViewController.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/8/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit
var cartItems = Array<Product>()
class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCartItems.count
        
        //return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
        let product = shoppingCartItems[indexPath.row]
        /* for item in shoppingCartItems {
         print(item.pid!, " ", item.des!, " ", item.details!, " ", item.price!, " ", item.quantity!, " ", item.shoppingQuantity!)
         //cartItems.append(item)
         }*/
        cell.lblItemName.text = "NAME : "+product.des!
        cell.lblDetail.text = "DETAILS : "+product.details!
        cell.lblPrice.text = "PRICE : "+String(product.price!)
        cell.lblQuantity.text = "QUANTITY : "+String(product.shoppingQuantity!)
        return cell
        
    }
    //func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // return 160
    // }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            shoppingCartItems.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let username:String? = UserDefaults.standard.string(forKey: "username")
        let userId:String? = UserDefaults.standard.string(forKey: "userId")

        print(username!+" "+userId!)
        
        print("shoppingCartItems.count: ", shoppingCartItems.count)
        
        for item in shoppingCartItems {
            print(item.pid!, " ", item.des!, " ", item.details!, " ", item.price!, " ", item.quantity!, " ", item.shoppingQuantity!)
        }
        
        tableView.reloadData()
        
        print("APPEAR")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LOAD")
        
        //tableView.dataSource = self
        //tableView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func proceedToCheckout(_ sender: UIButton) {
        if(shoppingCartItems.count > 0)
        {
            performSegue(withIdentifier: "checkout", sender: self)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Shopping Cart Empty !", preferredStyle: UIAlertControllerStyle.alert)
            let btnOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(btnOk)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
    }
    
    
    
}

