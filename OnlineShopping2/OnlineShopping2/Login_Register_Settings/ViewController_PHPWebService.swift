//
//  ViewController_PHPWebService.swift
//  OnlineShopping2
//
//  Created by Fan Zhongjie on 4/20/18.
//  Copyright © 2018 Fan Zhongjie, Luna Tejinder, Lin Junyu. All rights reserved.
//

import UIKit
import WebKit

class ViewController_PHPWebService: UIViewController {
    
    @IBOutlet weak var phpWebServiceWebKitView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://"+ViewController_Login.SERVER_IP + "/phpmyadmin")
        phpWebServiceWebKitView.load(URLRequest(url: url!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
