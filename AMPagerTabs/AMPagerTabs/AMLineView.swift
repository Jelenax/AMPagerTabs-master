//
//  AMLineView.swift
//  AMPagerTabs
//
//  Created by Angeles Jelena Lopez Fernandez on 12/06/18.
//  Copyright © 2018 Angeles Jelena Lopez Fernandez. All rights reserved.
//

import UIKit

class AMLineView: UIView {
    
    var lineHeight: CGFloat = 7
    var lineColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        drawSelectedTabLine()
        
    }
    
    private func drawSelectedTabLine(){
        let height = frame.height
        let width = frame.width
        let triangleSize:CGFloat = 5
        let path = UIBezierPath()
        
// Dibujo de las formas de las lineas
        path.move(to: CGPoint(x: 0, y: height-lineHeight))
        path.addLine(to: CGPoint(x: (width/2)-triangleSize, y: height-lineHeight))
        path.addLine(to: CGPoint(x: (width/2), y: height-lineHeight-triangleSize))
        path.addLine(to: CGPoint(x: (width/2)+triangleSize , y: height-lineHeight))
        path.addLine(to: CGPoint(x: width , y: height-lineHeight))
        path.addLine(to: CGPoint(x: width , y: height))
        path.addLine(to: CGPoint(x: 0 , y: height))
        path.addLine(to: CGPoint(x: 0 , y: height-lineHeight))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        clipsToBounds = true
    }

}
