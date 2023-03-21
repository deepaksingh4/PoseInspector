//
//  JointsOverlayView.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/20/23.
//

import UIKit

class JointsOverLayView: UIView {
    
    var joints: [CGPoint] = []{
        didSet{
            drawJoints()
        }
    }
    let previewOverlayLayer : CAShapeLayer = CAShapeLayer()
    var path = UIBezierPath()
    
    override var layer: CALayer{
        get{
            self.previewOverlayLayer
        }
    }
    func convertToViewCordinates(normalizedCoordinates: CGPoint){
        
    }
    
    func clearDrawing(){
        path.removeAllPoints()
    }
    
    func drawJoints(){
        
        joints.forEach {[weak self] point in
            let circlePath = UIBezierPath(arcCenter: point, radius: CGFloat(3), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            guard let self = self else {
                return
            }
            path.addArc(withCenter: point, radius: CGFloat(3), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
            self.previewOverlayLayer.path = path.cgPath
            // Change the fill color
            self.previewOverlayLayer.fillColor = UIColor.red.cgColor
            // You can change the stroke color
            self.previewOverlayLayer.strokeColor = UIColor.red.cgColor
            // You can change the line width
            self.previewOverlayLayer.lineWidth = 2.0
            
            DispatchQueue.main.async {
                self.layer.layoutIfNeeded()
            }
        }
    }
    
    
}
