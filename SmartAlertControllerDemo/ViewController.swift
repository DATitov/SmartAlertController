//
//  ViewController.swift
//  SmartAlertControllerDemo
//
//  Created by Dmitriy Titov on 16.06.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let manager = SAlertManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = UIColor.green
        
        
        manager.change(backgroundViewType: .defaultView)
        let av = DemoAlertView()
        let conf = SConfiguration()
        conf.topOffset = 40.0
        conf.viewHeight = 100.0
        conf.appearenceDirection = .top
        manager.add(alertView: av, configuration: conf)
        manager.present(aboveViewController: self)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 6)) {
//            manager.dismiss()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

