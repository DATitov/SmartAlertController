//
//  SConfiguration.swift
//  SmartAlertController
//
//  Created by Dmitriy Titov on 16.06.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

public class SConfiguration {

    var topOffset: CGFloat?
    var viewHeight: CGFloat?
    var bottomOffset: CGFloat?
    
    var leadingOffset: CGFloat?
    var trailingOffset: CGFloat?
    var viewWidth: CGFloat?
    
    var verticalBinding: SVerticalBinding = .center
    var horisontalBinding: SHorisontalBinding = .center
    
    var appearenceDirection: SAppearenceDirection = .top
    var dismissDirection: SAppearenceDirection?
    var appearenceAnimation: SAppearenceAnimation? = .none
    
    init() {
        
    }
    
}
