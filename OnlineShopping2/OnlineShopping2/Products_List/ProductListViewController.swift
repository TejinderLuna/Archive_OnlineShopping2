//
//  ProductListViewController.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/8/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit
// global shopping cart items list
var shoppingCartItems = Array<Product>()
class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProductModelProtocol, ProductCellDelegate {
    
    var feedItems: NSArray = NSArray()
    @IBOutlet weak var listTableView: UITableView!
    //@IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        
//        let username:String? = UserDefaults.standard.string(forKey: "username")
//        let userId:String? = UserDefaults.standard.string(forKey: "userId")
        //        usernameLabel.text = "Welcome, " + username! + " id: " + userId!
        
        let productModel = ProductMode()
        productModel.delegate = self
        productModel.downloadItems()
        
    }
    
    //download all products from database
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
    
    //Add product to Shopping cart
    func didAddToCart(product: Product, quantityToBuy:Int) {
        let alertTitle = "Add to cart"
        let message = "\(product.des!) added to Shopping cart"
        if(shoppingCartItems.contains(product))
        {
            let index:Int = shoppingCartItems.index(of: product)!
            
            shoppingCartItems[index].shoppingQuantity = shoppingCartItems[index].shoppingQuantity! + quantityToBuy
            shoppingCartItems[index].quantity = shoppingCartItems[index].quantity! - shoppingCartItems[index].shoppingQuantity!
        }
        else
        {
            product.shoppingQuantity = quantityToBuy
            product.quantity = product.quantity! - product.shoppingQuantity!
            shoppingCartItems.append(product)
        }
        
        
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //rows of table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    //show each row in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "productList") as! ProductListViewCell
        let item = feedItems[indexPath.row] as! Product
        cell.imgView.image = UIImage(named:item.des!)
        cell.setProduct(product: item)
        cell.delegate = self
        
        return cell
    }
    
    //forward to product details page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductDetail") as? ProductDetailControllerViewController
        let item = feedItems[indexPath.row] as! Product
        vc?.setProduct(product: item)
        vc?.delegate = self
        
        self.navigationController?.pushViewController(vc!, animated: true)
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

