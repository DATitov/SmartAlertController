
//
//  SmartAlertManager.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 21.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

public class SAlertManager {
    
    var animationsDuration: Double = 0.2 {
        didSet {
            viewController.animationsDuration = animationsDuration
        }
    }
    
    private let viewController = SAlertViewController()
    
    init() {
        viewController.backgroundPressed = { [weak self] in
            self?.dismiss()
        }
        viewController.set { [weak self] in
            self?.dismiss()
        }
    }
    
    func change(backgroundViewType: SBackgroundViewType) {
        viewController.change(backgrounType: backgroundViewType)
    }

    func present(aboveViewController viewController: UIViewController,
                 completion: (() -> Void)? = nil) {
        viewController.present(self.viewController, animated: false, completion: completion)
    }
    
    func dismiss() {
        viewController.dismiss { [weak self] in
            self?.removeAllAlerts()
        }
    }
    
    func set(acceptableVerticalScrollOffset: OffsetRange) {
        viewController.set(acceptableVerticalScrollOffset: acceptableVerticalScrollOffset)
    }
    
    func set(acceptableHorisontalScrollOffset: OffsetRange) {
        viewController.set(acceptableHorisontalScrollOffset: acceptableHorisontalScrollOffset)
    }
    
}

extension SAlertManager: SManagedAlertViewContainer {
    
    public func add(alertView alert: SmartAlertView, configuration: SConfiguration) {
        viewController.add(alertView: alert, configuration: configuration)
    }
    
    public func remove(alertView alert: SmartAlertView) {
        viewController.remove(alertView: alert)
    }
    
    public func removeAllAlerts() {
        viewController.removeAllAlerts()
    }
    
    public func update(alertView alert: SmartAlertView) {
        viewController.update(alertView: alert)
    }
    
    public func updateAllalertViews() {
        viewController.updateAllalertViews()
    }
    
    public func set(configuration: SConfiguration, toAlertView alert: SmartAlertView) {
        viewController.set(configuration: configuration, toAlertView: alert)
    }
    
}
