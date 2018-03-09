//
//  CropAreaView.swift
//  ImageCropper
//
//  Created by Jasmee Sengupta on 08/03/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//

import UIKit

class CropAreaView: UIView {
    var lineWidth = CGFloat(3.0)
    var path: UIBezierPath!
    var fillColor = UIColor.lightGray.withAlphaComponent(0.5)
    
    init(origin: CGPoint, width: CGFloat,   height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        _cropoptions = CROP_OPTIONS()
        _cropoptions.Center = origin
        let insetRect = self.bounds.insetBy(dx: lineWidth, dy: lineWidth)
        self.path = UIBezierPath(roundedRect: insetRect, cornerRadius: 0.0)
        self.center = origin
        self.layer.backgroundColor = UIColor(red: 0.09, green: 0.56, blue: 0.8, alpha: 0.2).cgColor
        _cropoptions.Width = self.bounds.width
        _cropoptions.Height = self.bounds.height
        self.backgroundColor = UIColor.clear
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panning(_:))))
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinching(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panning(_ panGR: UIPanGestureRecognizer) {
        self.superview!.bringSubview(toFront: self)
        var translation = panGR.translation(in: self)
        translation = translation.applying(self.transform)
        self.center.x += translation.x
        self.center.y += translation.y
        panGR.setTranslation(CGPoint.zero, in: self)
        _cropoptions.Center = self.center
    }
    
    @objc func pinching(_ pinchGR: UIPinchGestureRecognizer) {
        self.superview!.bringSubview(toFront: self)
        let scale = pinchGR.scale
        self.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        _cropoptions.Height = self.frame.height
        _cropoptions.Width = self.frame.width
        pinchGR.scale = 1.0
    }
    
    override func draw(_ rect: CGRect) {
        self.fillColor.setFill()
        self.path.fill()
        self.path.lineWidth = self.lineWidth
        UIColor.white.setStroke()
        self.path.stroke()
    }

}
