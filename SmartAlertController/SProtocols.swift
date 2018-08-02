//
//  SProtocols.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 16.06.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

public typealias SmartAlertView = (UIView & SAlertView)

public protocol SAlertView {
    
//    var configuration: SConfiguration? { get set }
    
}

public protocol SManagedAlertViewContainer: class {
    
    func add(alertView alert: SmartAlertView, configuration: SConfiguration)
    func remove(alertView alert: SmartAlertView)
    
    func removeAllAlerts()
    
    func update(alertView alert: SmartAlertView)
    func updateAllalertViews()
    
    func set(configuration: SConfiguration, toAlertView alert: SmartAlertView)
    
}

@objc protocol Appearable: class {
    
    func appear(animated: Bool)
    func dismiss()
    
    @objc optional func dismissAnimated(completion: @escaping () -> ())
    
}
