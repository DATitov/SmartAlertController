//
//  MainTableViewController.swift
//  SmartAlertControllerDemo
//
//  Created by Dmitriy Titov on 27.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    let manager = SAlertManager()
    
    @IBOutlet var animationsDurationsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func AnimationDurationSliderValueChanged(_ sender: Any) {
        guard let slider = sender as? UISlider else { return }
        let minVal = 0.2
        let maxVal = 2.0
        manager.animationsDuration = minVal + (maxVal - minVal) * Double(slider.value)
        animationsDurationsLabel.text = String(format: "%.1f", manager.animationsDuration)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            presentBindingsTest()
        case 1:
            presentAppearenceTest()
        case 2:
            presentDurationTest()
        case 3:
            presentKayboardObservingTest()
        default:
            return
        }
    }
    
    func presentBindingsTest() {
        manager.change(backgroundViewType: .defaultView)
            
        _ = {
            let av = DemoAlertView()
            av.manager = manager
            let conf = SConfiguration()
            av.configuration = conf
            conf.topOffset = 70.0
            conf.viewHeight = 200.0
            conf.viewWidth = 200.0
            conf.verticalBinding = .top
            conf.horisontalBinding = .left
            conf.appearenceDirection = .left
            conf.dismissDirection = .right
            manager.add(alertView: av, configuration: conf)
        }()
        
        manager.present(aboveViewController: self)
    }
    
    func presentAppearenceTest() {
        manager.change(backgroundViewType: .defaultView)
        
        _ = { [weak self] in
            let alert = AppearenceManagerAlertView()
            alert.manager = self?.manager
            
            let conf = SConfiguration()
            conf.bottomOffset = 20.0
            conf.leadingOffset = 20.0
            conf.verticalBinding = .bottom
            conf.horisontalBinding = .center
            conf.viewHeight = 200
            conf.appearenceDirection = .bottom
            self?.manager.add(alertView: alert, configuration: conf)
        }()
        
        manager.set(acceptableVerticalScrollOffset: OffsetRange(max: 50))
        manager.present(aboveViewController: self)
    }
    
    func presentDurationTest() {
        
        _ = {
            let av = DemoAlertView()
            av.manager = manager
            let conf = SConfiguration()
            av.configuration = conf
            conf.topOffset = 70.0
            conf.viewHeight = 200.0
            conf.viewWidth = 200.0
            conf.verticalBinding = .top
            conf.horisontalBinding = .left
            conf.appearenceDirection = .left
            conf.dismissDirection = .right
            manager.add(alertView: av, configuration: conf)
        }()
        
        _ = { [weak self] in
            let alert = AnimationDurationAlertView()
            alert.manager = self?.manager
            
            let conf = SConfiguration()
            conf.bottomOffset = 20.0
            conf.leadingOffset = 20.0
            conf.verticalBinding = .bottom
            conf.horisontalBinding = .center
            conf.viewHeight = 100
            conf.appearenceDirection = .bottom
            self?.manager.add(alertView: alert, configuration: conf)
        }()
        
        manager.set(acceptableVerticalScrollOffset: OffsetRange(max: 50))
        manager.present(aboveViewController: self)
    }
    
    func presentKayboardObservingTest() {
        _ = { [weak self] in
            let alert = KeyboardObservingView()
            alert.manager = self?.manager
            let conf = SConfiguration()
            alert.conf = conf
            conf.viewHeight = 100
            conf.leadingOffset = 26
            self?.manager.add(alertView: alert, configuration: conf)
        }()
        
        manager.set(acceptableVerticalScrollOffset: OffsetRange(min: -50, max: 50))
        manager.present(aboveViewController: self)
    }

}
