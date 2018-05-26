//
//  Product.swift
//  OnlineShopping2
//
//  Created by Lin Junyu on 4/12/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

class Product: NSObject {
    
    //properties
    var pid:Int?
    var des:String?
    var details:String?
    var price:Double?
    var quantity:Int?
    var shoppingQuantity:Int?
    //empty constructor
    override init() {
        
    }
    
    //construct with parameters
    init(pid:Int, des:String, details:String, price:Double, quantity:Int) {
        self.pid = pid
        self.des = des
        self.details = details
        self.price = price
        self.quantity = quantity
        self.shoppingQuantity = 0
    }
    
    
}

