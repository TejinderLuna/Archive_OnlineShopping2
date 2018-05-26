//
//  ProductDetailControllerViewController.swift
//  OnlineShopping2
//
//  Created by Lin Junyu on 4/13/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

class ProductDetailControllerViewController: UIViewController{
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    var productItem:Product!
    var delegate: ProductCellDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = UIImage(named: productItem.des!)
        des.text = productItem.des!
        txtQuantity.text = "1"
        btnAdd.layer.cornerRadius = 10
        textView.text = ("Product Details: \(String(describing: productItem.details!)) \n Quantity: \(String(describing: productItem.quantity!)) left\n Price: $\(String(describing: productItem.price!)) CAD")
        
        //        lblDes.text = productItem.des!
        //        lblDetaiPrice.text = ("$\(String(describing: productItem.price!)) CAD")
        //        lblDetailDetail.text = productItem.details!
        //        imgDetail.image = UIImage(named: productItem.des!)
        //        lblQuantity.text = ("\(String(describing: productItem.quantity!)) left")
    }
    
    func setProduct(product:Product){
        productItem = product
    }
    
    
    @IBAction func addToCart(_ sender: UIButton) {
        let quantityToBuy = Int(txtQuantity.text!)
        delegate?.didAddToCart(product: productItem, quantityToBuy: quantityToBuy!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

