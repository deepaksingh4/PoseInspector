//
//  JointsOverlayView.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/20/23.
//

import UIKit

class JointsOverLayView: UIView {
    
    var joints: [JointLine] = []{
        didSet{
            drawJoints()
        }
    }
    var previewOverlayLayer : CAShapeLayer = CAShapeLayer()
    
    
    override var layer: CALayer{
        get{
            self.previewOverlayLayer
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.previewOverlayLayer.frame = self.frame
        self.previewOverlayLayer.strokeColor = UIColor.green.cgColor
        self.previewOverlayLayer.lineWidth = 3.0
        self.previewOverlayLayer.fillColor = UIColor.clear.cgColor
        self.previewOverlayLayer.fillRule = .evenOdd
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawJoints(){
        let path = CGMutablePath()
        
        joints.forEach { jointLine in
            print(jointLine.name)
            let error = CAShapeLayer()
            error.frame = self.previewOverlayLayer.frame
            error.name = jointLine.name
            error.lineWidth = 3
            error.fillColor = UIColor.clear.cgColor
            error.strokeColor = UIColor.red.cgColor
            let joint = jointLine.jointPoints
            
            let _ = self.previewOverlayLayer.sublayers?.filter({ layer in
                return layer.name == jointLine.name
            }).forEach({ layer in
                layer.removeFromSuperlayer()
            })
            
            if jointLine.error != nil{
                self.previewOverlayLayer.addSublayer(error)
            }
            if joint.count > 0 {
                path.move(to: joint[0]!)
            }
            joint.forEach { point in
                path.addLine(to: point!)
            }
            error.path = path
            self.previewOverlayLayer.path = path
            DispatchQueue.main.async {
                self.previewOverlayLayer.didChangeValue(forKey: "path")
            }
        }
        
        
    }
    
}
