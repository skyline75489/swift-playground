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
        let router = SwiftRouter.sharedInstance
                
        router.map("/front", controllerClass: FrontPageViewController.self)
        router.map("/detail", controllerClass: DetailViewController.self)
        
        
        router.map("/func", handler: { (param: [String:String]?) -> (Bool)  in
            print("In Closure")
            return true
        });
        
    
        if let v1 = router.matchController("/front") {
            print(v1)
        }
        
        if let v2 = router.matchHandler("/func") {
            let r = v2(nil)
            print(r)
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

