//
//  AMTabButton.swift
//  AMPagerTabs
//
//  Created by Angeles Jelena Lopez Fernandez on 12/06/18.
//  Copyright © 2018 Angeles Jelena Lopez Fernandez. All rights reserved.
//

import UIKit

class AMTabButton: UIButton {
    
    var index: Int?

    override func draw(_ rect: CGRect) {
        addTabSeparatorLine()
        
    }
    
// separación de las lineas de las pestañas
    private func addTabSeparatorLine(){
        let gradientMaskLayer: CAGradientLayer = CAGradientLayer()
        gradientMaskLayer.frame = self.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientMaskLayer.locations = [0.0, 0.5]
        gradientMaskLayer.frame = CGRect(x: 0, y: 0, width: 0.5, height: self.frame.height)
        self.layer.addSublayer(gradientMaskLayer)
        
    }

}
