//
//  SmartAlertsContainer.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 21.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class SAlertsContainer: UIView {
    
    var appeared = false
    var acceptableHorisontalScrollOffset: OffsetRange?
    var acceptableVerticalScrollOffset: OffsetRange?
    
    var animationsDuration: Double = 0.2 {
        didSet {
            self.alertContainers.forEach({
                $0.animationsDuration = animationsDuration
            })
        }
    }

    var alertContainers = [SAlertContainer]()
    
    private var tapGR = UITapGestureRecognizer()
    
    var backgroundPressed: (() -> ())?
    var notAcceptableOffsetReached: (() -> ())?
    
    fileprivate let layoutCalculator = LayoutCalculator()
    
    let scrollView = UIScrollView()

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    func setupUI() {
        addSubview(scrollView)
        addGestureRecognizer(tapGR)
        tapGR.addTarget(self, action: #selector(SAlertsContainer.backgroundTapped))
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func backgroundTapped(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: scrollView)
        guard let action = backgroundPressed,
            alertContainers.filter({ $0.frame.contains(tapPoint) }).count < 1
            else { return }
        action()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: frame.size.width, height: frame.size.height + 1)
        layout(animated: false, completion: {  })
    }
    
    fileprivate func layout(animated: Bool, completion: @escaping () -> ()) {
        let availableSize = frame.size
        alertContainers.forEach({
            $0.availableSize = availableSize
            $0.layout(animated: animated)
        })
    }
    
    // MARK: Helpers
    
    fileprivate func container(forAlert alert: UIView) -> SAlertContainer? {
        return alertContainers.filter({ $0.alertView.isEqual(alert) }).first
    }
    
}

extension SAlertsContainer: SManagedAlertViewContainer {
    
    func add(alertView alert: UIView, configuration: SConfiguration) {
        let container = SAlertContainer(alertView: alert,
                                        configuration: configuration,
                                        layoutCalculator: layoutCalculator)
        container.animationsDuration = animationsDuration
        alertContainers.append(container)
        scrollView.addSubview(container)
        container.setNeedsLayout()
        container.availableSize = frame.size
        if appeared {
            container.appear(animated: true)
        }
    }
    
    func remove(alertView alert: UIView) {
        guard let container = container(forAlert: alert),
            let index = alertContainers.index(of: container)
            else { return }
        
        alertContainers.remove(at: index)
        container.dismissAnimated {
            container.removeFromSuperview()
        }
    }
    
    func removeAllAlerts() {
        alertContainers.forEach({ $0.removeFromSuperview() })
        alertContainers = [SAlertContainer]()
    }
    
    func update(alertView alert: UIView) {
        guard let container = container(forAlert: alert) else { return }
        container.layout(animated: true)
    }
    
    func updateAllalertViews() {
        alertContainers.forEach({
            $0.layout(animated: true)
        })
    }
    
    func set(configuration: SConfiguration, toAlertView alert: UIView) {
        guard let container = container(forAlert: alert) else { return }
        container.configuration = configuration
        container.layout(animated: true)
    }
    
}

extension SAlertsContainer: Appearable {
    
    func appear(animated: Bool) {
        layout(animated: false, completion: {  })
        alertContainers.forEach({
            $0.appear(animated: animated)
        })
    }
    
    func dismiss() {
        alertContainers.forEach({
            $0.dismiss()
        })
    }
    
}

extension SAlertsContainer: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let range = acceptableHorisontalScrollOffset, !range.inRange(value: scrollView.contentOffset.x) {
            notAcceptableOffsetReached?()
        }else if let range = acceptableVerticalScrollOffset, !range.inRange(value: scrollView.contentOffset.y) {
            notAcceptableOffsetReached?()
        }
    }
    
}
