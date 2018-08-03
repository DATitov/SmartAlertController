//
//  AnimationDurationAlertView.swift
//  SmartAlertControllerDemo
//
//  Created by Dmitriy Titov on 02.08.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class AnimationDurationAlertView: UIView {
    
    var manager: SAlertManager? {
        didSet {
            if let duration = manager?.animationsDuration {
                slider.value = Float(percentage(forValue: duration))                
                durationLabel.text = String(format: "%.1f", duration)
            }
        }
    }

    let titleLabel = UILabel()
    let durationLabel = UILabel()
    let minLabel = UILabel()
    let maxLabel = UILabel()
    
    let slider = UISlider()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 5
        
        for label in [titleLabel, durationLabel, minLabel, maxLabel, slider] {
            addSubview(label)
        }
        for label in [durationLabel, maxLabel] {
            label.textAlignment = .right
        }
        
        titleLabel.text = "Animatinos duration"
        minLabel.text = "0.2"
        maxLabel.text = "2.0"
        
        slider.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func valueChanged(sender: UISlider) {
        manager?.animationsDuration = value(forPercentage: Double(sender.value))
        if let duration = manager?.animationsDuration {
            durationLabel.text = String(format: "%.1f", duration)
        }
    }
    
    func value(forPercentage perc: Double) -> Double {
        let minValue = 0.2
        let maxValue = 2.0
        return minValue + (maxValue - minValue) * Double(perc)
    }
    
    func percentage(forValue value: Double) -> Double {
        let minValue = 0.2
        let maxValue = 2.0
        let delt = maxValue - minValue
        return (value - minValue) / delt
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horOffset: CGFloat = 16.0
        let vertOffset: CGFloat = 10.0
        
        let height: CGFloat = 30.0
        let betweetItemsSpace: CGFloat = 5
        
        _ = { [unowned self] in
            let durationWidth: CGFloat = 60
            self.durationLabel.frame = CGRect(x: self.frame.size.width - durationWidth - horOffset, y: vertOffset, width: durationWidth, height: height)
            self.titleLabel.frame = CGRect(x: horOffset, y: vertOffset,
                                           width: self.frame.size.width - betweetItemsSpace - 2.0 * horOffset,
                                           height: height)
        }()
        
        let rangeLabelWidth: CGFloat = 30
        minLabel.frame = CGRect(x: horOffset, y: frame.size.height - height - vertOffset,
                                width: rangeLabelWidth, height: height)
        maxLabel.frame = CGRect(x: frame.size.width - rangeLabelWidth - horOffset,
                                y: frame.size.height - height - vertOffset,
                                width: rangeLabelWidth, height: height)
        slider.frame = CGRect(x: horOffset + rangeLabelWidth + betweetItemsSpace,
                                y: frame.size.height - height - vertOffset,
                                width: frame.size.width - 2.0 * (rangeLabelWidth + horOffset + betweetItemsSpace),
                                height: height)
    }

}
