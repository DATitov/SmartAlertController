//
//  AlertManagerView.swift
//  SmartAlertControllerDemo
//
//  Created by Dmitriy Titov on 29.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

protocol AlertManagerViewDelegate: class {
    func add(alertView: TitledAlertView, configuration: SConfiguration)
    func remove(alertView: TitledAlertView)
}

class AlertManagerView: UIView {
    
    weak var delegate: AlertManagerViewDelegate?
    
    var alertView: TitledAlertView!
    var configuration: SConfiguration!
    
    let titleLabel = UILabel()
    let addButton = UIButton()

    let removeButton = UIButton()

    init(name: String, conf: SConfiguration) {
        super.init(frame: .zero)
        titleLabel.text = name
        configuration = conf
        alertView = TitledAlertView(title: name)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func setupUI() {
        for view in [
            titleLabel
            , addButton
            , removeButton
            ] {
                addSubview(view)
        }
        
        let buttons = [addButton, removeButton]
        let actions = ["add", "remove"]
        let titles = ["Add", "Remove"]
        let colors = [UIColor.green, UIColor.orange]
        
        for (button, action) in zip(buttons, actions) {
                                        button.addTarget(self, action: Selector(action), for: .touchUpInside)
        }
        
        for (button, (title, color)) in zip(buttons, zip(titles, colors)) {
                                                    button.setTitle(title, for: .normal)
                                                    button.setTitleColor(color, for: .normal)
        }
        
    }
    
    @objc func add() {
        delegate?.add(alertView: alertView, configuration: configuration)
    }
    
    @objc func remove() {
        delegate?.remove(alertView: alertView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelWidth: CGFloat = 65.0
        let horOffset: CGFloat = 16
        let height: CGFloat = 25
        let yCoord = (frame.size.height - height) / 2.0
        let buttonWidth = (frame.size.width - 4.0 * horOffset - labelWidth) / 2.0
        let frames = [
            CGRect(x: horOffset, y: yCoord, width: labelWidth, height: height),
            CGRect(x: 2.0 * horOffset + labelWidth, y: yCoord, width: buttonWidth, height: height),
            CGRect(x: 3.0 * horOffset + labelWidth + buttonWidth, y: yCoord, width: buttonWidth, height: height)
        ]
        for (view, frame) in zip([ titleLabel, addButton, removeButton ],
                                 frames) {
                                    view.frame = frame
        }
    }
    
}
