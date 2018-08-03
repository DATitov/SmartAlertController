//
//  SProtocols.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 16.06.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

public protocol SManagedAlertViewContainer: class {
    
    func add(alertView alert: UIView, configuration: SConfiguration)
    func remove(alertView alert: UIView)
    
    func removeAllAlerts()
    
    func update(alertView alert: UIView)
    func updateAllalertViews()
    
    func set(configuration: SConfiguration, toAlertView alert: UIView)
    
}

@objc protocol Appearable: class {
    
    func appear(animated: Bool)
    func dismiss()
    
    @objc optional func dismissAnimated(completion: @escaping () -> ())
    
}
