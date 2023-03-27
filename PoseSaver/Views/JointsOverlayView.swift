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
           
            let joint = jointLine.jointPoints
            
            if jointLine.error != nil{
                let message = getErrorMessage(error: jointLine.error)
                self.showErrorMessage(message: message)
            }
            if joint.count > 0 {
                path.move(to: joint[0]!)
            }
            joint.forEach { point in
                path.addLine(to: point!)
            }

            self.previewOverlayLayer.path = path
            DispatchQueue.main.async {
                self.previewOverlayLayer.didChangeValue(forKey: "path")
            }
        }
    }
    
    
    
    func showErrorMessage(message: String){
        Alerts.shared.showErrorView(message: message)
    }
    
    func hideErrorMessage(){
        Alerts.shared.hideAlert()
    }
    func getErrorMessage(error: SittingPostureError?) -> String{
        guard let error = error else{
            return "Bad error"
        }
        switch error{
            
        case .WRONG_ELBOW_ANGLE:
            return "Please correct your elbow joint, try keeping them as close to 90 degree (⎿)"
        case .WRONG_KNEE_ANGLE:
            return "Please correct you knee joint, try keeping them as close to 90 degree(⏋) to the ground"
        }
        
    }
}

