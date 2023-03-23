//
//  JointsOverlayView.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/20/23.
//

import UIKit

class JointsOverLayView: UIView {
    
    var joints: [[CGPoint]] = []{
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawJoints(){
        let path = CGMutablePath()
        
        joints.forEach { joint in
            if joint.count > 0 {
                path.move(to: joint[0])
            }
            joint.forEach { point in
                path.addLine(to: point)
            }
        }
        self.previewOverlayLayer.path = path
        DispatchQueue.main.async {
            self.previewOverlayLayer.didChangeValue(forKey: "path")
        }
        
    }
    
}
