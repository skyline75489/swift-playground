//
//  ViewController.swift
//  Swift-Playground
//
//  Created by skyline on 15/9/22.
//  Copyright © 2015年 skyline. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "https://httpbin.org/get")
            .responseJSON { _, _, result in
                print(result)
                debugPrint(result)
                
                print("Parsed JSON: \(result.value)")
        }

        
        Alamofire.request(.GET, "https://httpbin.org/get")
            .responseString { _, _, result in
                print("Response String: \(result.value)")
            }
            .responseJSON { _, _, result in
                print("Response JSON: \(result.value)")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

