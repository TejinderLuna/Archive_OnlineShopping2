//
//  ProductListViewCell.swift
//  OnlineShopping2
//
//  Created by Lin Junyu on 4/12/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    func didAddToCart(product:Product, quantityToBuy:Int)
}

class ProductListViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    
    
    var productItem:Product!
    var delegate: ProductCellDelegate?
    
    func setProduct(product:Product){
        productItem = product
        lblDescription.text = product.des
        lblPrice.text = ("$\(String(describing: product.price!)) CAD")
    }
    @IBAction func addToCart(_ sender: UIButton) {
        delegate?.didAddToCart(product: productItem, quantityToBuy: 1)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnAdd.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

