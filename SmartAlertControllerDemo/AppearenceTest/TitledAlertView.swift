//
//  TitledAlertView.swift
//  SmartAlertControllerDemo
//
//  Created by Dmitriy Titov on 29.07.2018.
//  Copyright © 2018 DmitriyTitov. All rights reserved.
//

import UIKit

class TitledAlertView: SmartAlertView {

    let titleLabel = UILabel()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.textAlignment = .center
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
    }

}
