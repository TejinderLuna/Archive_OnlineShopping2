//
//  ProductMode.swift
//  OnlineShopping2
//
//  Created by Lin Junyu on 4/12/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

protocol ProductModelProtocol : class {
    func itemsDownloaded(items: NSArray)
}

class ProductMode: NSObject, URLSessionDataDelegate{
    
    //properties
    weak var delegate : ProductModelProtocol!
    //this will be changed to the path where getProductList.php lives
    let url = URL(string: "http://" + ViewController_Login.SERVER_IP + "/iosproject/getProductList.php")
    
    func downloadItems(){
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url!) { (data,response,error) in
            if error != nil {
                print("Failed to download data")
            } else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let products = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let product = Product()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let pid = jsonElement["pid"] as? String,
                let des = jsonElement["description"] as? String,
                let details = jsonElement["details"] as? String,
                let price = jsonElement["price"] as? String,
                let quantity = jsonElement["quantity"] as? String
            {
                
                product.pid = Int(pid)
                product.des = des
                product.details = details
                product.price = Double(price)
                product.quantity = Int(quantity)
                
            }
            
            products.add(product)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: products)
            
        })
    }
    
}

