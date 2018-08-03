//
//  AppearenceManagerAlertView.swift
//  SmartAlertControllerDemo
//
//  Created by Dmitriy Titov on 29.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

typealias VoidClosure = () -> ()

class AppearenceManagerAlertView: UIView {
    
    weak var manager: SAlertManager?
    
    var configuration: SConfiguration?
    
    let alert1ManagerView = AlertManagerView(name: "Alert 1", conf: {
        let conf = SConfiguration()
        conf.bottomOffset = 20.0
        conf.leadingOffset = 20.0
        conf.verticalBinding = .center
        conf.horisontalBinding = .left
        conf.viewHeight = 40
        conf.viewWidth = 60
        conf.appearenceDirection = .left
        return conf
    }())
    let alert2ManagerView = AlertManagerView(name: "Alert 2", conf: {
        let conf = SConfiguration()
        conf.bottomOffset = 20.0
        conf.leadingOffset = 20.0
        conf.verticalBinding = .center
        conf.horisontalBinding = .right
        conf.viewHeight = 40
        conf.viewWidth = 60
        conf.appearenceDirection = .right
        return conf
    }())
    let alert3ManagerView = AlertManagerView(name: "Alert 3", conf: {
        let conf = SConfiguration()
        conf.bottomOffset = 20.0
        conf.leadingOffset = 20.0
        conf.verticalBinding = .top
        conf.horisontalBinding = .center
        conf.viewHeight = 40
        conf.viewWidth = 60
        conf.appearenceDirection = .top
        return conf
    }())
    let removeAllButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        for view in views() {
            addSubview(view)
        }
        
        for managerView in managerViews() {
            managerView.delegate = self
        }
        removeAllButton.setTitle("Remove all alerts", for: .normal)
        removeAllButton.setTitleColor(UIColor.red, for: .normal)
        removeAllButton.addTarget(self, action: #selector(removeAllAlerts), for: .touchUpInside)
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
    }
    
    @objc func removeAllAlerts() {
        for alertManager in managerViews() {
            alertManager.remove()
        }
    }
    
    func managerViews() -> [AlertManagerView] {
        return [
            alert1ManagerView
            , alert2ManagerView
            , alert3ManagerView
        ]
    }
    
    func views() -> [UIView] {
        return managerViews() + [removeAllButton]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let views = self.views()
        guard views.count > 0 else { return }
        let height = frame.size.height / CGFloat(views.count)
        for (i, view) in views.enumerated() {
            view.frame = CGRect(x: 0, y: CGFloat(i) * height , width: frame.size.width, height: height)
        }
    }

}

extension AppearenceManagerAlertView: AlertManagerViewDelegate {
    
    func add(alertView: TitledAlertView, configuration: SConfiguration) {
        manager?.add(alertView: alertView, configuration: configuration)
    }
    
    func remove(alertView: TitledAlertView) {
        manager?.remove(alertView: alertView)
    }
    
}
