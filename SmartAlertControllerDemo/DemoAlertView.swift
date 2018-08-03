//
//  DemoAlertView.swift
//  SmartAlertControllerDemo
//
//  Created by Dmitriy Titov on 17.06.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit
import SmartAlertController

class DemoAlertView: UIView {
    
    weak var manager: SAlertManager?
    
    var configuration: SConfiguration?      

    let dismissDirectionSegmControl = UISegmentedControl(items: ["nd", "Top", "Bottom", "Left", "Right"])
    let verticalBindingSegmControl = UISegmentedControl(items: ["Top", "center", "Bottom"])
    let horisontalBindingSegmControl = UISegmentedControl(items: ["Left", "center", "Right", "All space"])
    
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
            view.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        }
        
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
    }
    
    func views() -> [UISegmentedControl] {
        return [
            dismissDirectionSegmControl,
            verticalBindingSegmControl,
            horisontalBindingSegmControl
        ]
    }
    
    @objc func valueChanged(sender: UISegmentedControl) {
        if sender.isEqual(dismissDirectionSegmControl) {
            let values: [SAppearenceDirection] = [.top, .bottom, .left, .right]
            if sender.selectedSegmentIndex == 0 {
                configuration?.dismissDirection = nil
            }else{
                configuration?.dismissDirection = values[sender.selectedSegmentIndex - 1]
            }
        }else if sender.isEqual(verticalBindingSegmControl) {
            let values: [SVerticalBinding] = [.top, .center, .bottom]
            configuration?.verticalBinding = values[sender.selectedSegmentIndex]
        }else if sender.isEqual(horisontalBindingSegmControl) {
            let values: [SHorisontalBinding] = [.left, .center, .right, .allSpace]
            configuration?.horisontalBinding = values[sender.selectedSegmentIndex]
        }
        manager?.update(alertView: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let views = self.views()
        guard views.count > 0 else { return }
        
        let vertOffset: CGFloat = 5
        let betweenSpace: CGFloat = vertOffset - 2
        let height: CGFloat = (frame.size.height - 2.0 * vertOffset - CGFloat(views.count - 1) * betweenSpace) / CGFloat(views.count)
        let horOffset: CGFloat = 16
        let width: CGFloat = frame.size.width - 2.0 * horOffset
        
        let viewIsSingle = views.count == 1
        for (i, view) in views.enumerated() {
            let y = vertOffset + CGFloat(i) * (height + (viewIsSingle ? 0 : betweenSpace))
            view.frame = CGRect(x: horOffset, y: y,
                                width: width, height: height)
        }
    }

}
