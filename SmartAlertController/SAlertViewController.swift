//
//  SAlertViewController.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 16.06.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class SAlertViewController: UIViewController {

    var appeared = false {
        didSet {
            container.appeared = appeared
        }
    }
    
    var animationsDuration: Double = 0.2 {
        didSet {
            backgroundView.animationsDuration = animationsDuration
            container.animationsDuration = animationsDuration
        }
    }
    let backgroundView = SBackgroundView()
    let container = SAlertsContainer()
    
    var firstLayoutPassed = false
    
    var backgroundPressed: (() -> ())?
    
    func change(backgrounType type: SBackgroundViewType) {
        backgroundView.change(backgrounType: type)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        
        for view in [backgroundView ,container] {
            self.view.addSubview(view)
        }
        
        container.backgroundPressed = { [weak self] in
            guard let action = self?.backgroundPressed else { return }
            action()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstLayoutPassed {
            appear()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in [backgroundView, container] {
            view.frame = self.view.bounds
        }
        
        if !firstLayoutPassed {
            appear()
            firstLayoutPassed = true
        }
    }
    
    private func appear() {
        ([ backgroundView, container] as [Appearable]).forEach({ $0.appear(animated: true) })
        appeared = true
    }
    
    func dismiss(_ completion: @escaping () -> ()) {
        let views: [Appearable] = [backgroundView, container] as [Appearable]
        UIView.animate(withDuration: animationsDuration,
                       animations: {
                        views.forEach({
                            $0.dismiss()
                        })
        }) { _ in
            self.container.removeAllAlerts()
            super.dismiss(animated: false,
                          completion: nil)
            completion()
            self.appeared = false
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
    
    func configureView() {
        view.backgroundColor = UIColor.clear;
    }
    
    func set(acceptableVerticalScrollOffset: OffsetRange) {
        container.acceptableVerticalScrollOffset = acceptableVerticalScrollOffset
    }
    
    func set(acceptableHorisontalScrollOffset: OffsetRange) {
        container.acceptableHorisontalScrollOffset = acceptableHorisontalScrollOffset
    }
    
    func set(notAcceptableScrollOffsetReached: @escaping () -> ()) {
        container.notAcceptableOffsetReached = notAcceptableScrollOffsetReached
    }

}

extension SAlertViewController: SManagedAlertViewContainer {
    
    func add(alertView alert: SmartAlertView, configuration: SConfiguration) {
        container.add(alertView: alert, configuration: configuration)
    }
    
    func remove(alertView alert: SmartAlertView) {
        container.remove(alertView: alert)
    }
    
    func removeAllAlerts() {
        container.removeAllAlerts()
    }
    
    func update(alertView alert: SmartAlertView) {
        container.update(alertView: alert)
    }
    
    func updateAllalertViews() {
        container.updateAllalertViews()
    }
    
    func set(configuration: SConfiguration, toAlertView alert: SmartAlertView) {
        container.set(configuration: configuration, toAlertView: alert)
    }
    
}
