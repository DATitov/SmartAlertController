//
//  ResizeTestView.swift
//  SmartAlertControllerDemo
//
//  Created by Виолетта Веселкова on 05.08.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class ResizeTestView: UIView {

    var manager: SAlertManager?
    var conf: SConfiguration?
    
    let titleLabel = UILabel()
    let makeBiggerButton = UIButton()
    let makeSmallerButton = UIButton()
    
    var allowPasswordEntry = false
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 5.0
        
        for view in [
            titleLabel,
            makeBiggerButton,
            makeSmallerButton
            ] {
            addSubview(view)
        }
        titleLabel.text = "Alert resizing test"
        
        for (button, (title, action)) in zip([makeBiggerButton, makeSmallerButton],
                                             zip(["Make bigger", "Make smaller"],
                                                 [#selector(ResizeTestView.makeBigger), #selector(ResizeTestView.makeSmaller)])) {
                                                    button.setTitleColor(UIColor.blue, for: .normal)
                                                    button.setTitle(title, for: .normal)
                button.addTarget(self, action: action, for: .touchUpInside)
        }
    }
    
    @objc func makeBigger() {
        changeSize(diff: 50)
    }
    
    @objc func makeSmaller() {
        changeSize(diff: -50)
    }
    
    func changeSize(diff: CGFloat) {
        if let conf = conf, conf.viewHeight != nil {
            conf.viewHeight! += diff
        }
        manager?.update(alertView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let vertOffset: CGFloat = 15
        let horOffset: CGFloat = 16
        let betweenSpace: CGFloat = 10
        let height: CGFloat = 40
        let width = frame.size.width - 2.0 * horOffset
        
        titleLabel.frame = CGRect(x: horOffset, y: vertOffset, width: width, height: height)
        makeBiggerButton.frame = CGRect(x: horOffset,
                                        y: frame.size.height - 2.0 * height - betweenSpace - vertOffset,
                                        width: width,
                                        height: height)
        makeSmallerButton.frame = CGRect(x: horOffset,
                                        y: frame.size.height - height - vertOffset,
                                        width: width,
                                        height: height)
    }

}
