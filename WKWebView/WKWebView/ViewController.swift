//
//  ViewController.swift
//  WKWebView
//
//  Created by Kishor Pahalwani on 30/05/18.
//  Copyright © 2018 Kishor Pahalwani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func gotoWebView(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WKWebViewController") as? WKWebViewController {
            self.navigationController?.show(vc, sender: nil)
        } 
    }
}

