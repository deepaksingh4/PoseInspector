//
//  JointValidator.swift
//  PoseSaver
//
//  Created by Deepak on 25/03/23.
//

import Foundation
import CoreGraphics
import VisionKit
import Vision

struct JointValidator {
    
    func createJointLine(name: JointGroup, points: [VNHumanBodyPoseObservation.JointName : CGPoint?]) -> JointLine {
        switch name{
        
        case .leftHand:
            guard let leftShoulder = points[.leftShoulder] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            guard let leftElbow = points[.leftElbow] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            guard let leftWrist = points[.leftWrist] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            
            
            return JointLine(name: name.rawValue, jointPoints: [leftShoulder, leftElbow, leftWrist], error: .WRONG_ELBOW_ANGLE)
            
        case .rightHand:
            guard let shoulder = points[.rightShoulder] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            guard let elbow = points[.rightElbow] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            guard let wrist = points[.rightWrist] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            
            return JointLine(name: name.rawValue, jointPoints: [shoulder, elbow, wrist], error: .WRONG_ELBOW_ANGLE)
            
        case .leftLeg:
            guard let hip = points[.leftHip] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            guard let knee = points[.leftKnee] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            guard let ankle = points[.leftAnkle] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            
            return JointLine(name: name.rawValue, jointPoints: [hip, knee, ankle], error: .WRONG_ELBOW_ANGLE)
            
        case .rightLeg:
            guard let hip = points[.rightHip] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            guard let knee = points[.rightKnee] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            guard let ankle = points[.rightAnkle] else{
                let values = points.values.compactMap { point in
                    point
                }
                
                return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            }
            
            
            return JointLine(name: name.rawValue, jointPoints: [hip, knee, ankle], error: .WRONG_ELBOW_ANGLE)
            
        default:
            let values = points.values.compactMap { point in
                point
            }
            
            return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            
        }
    }
    
    func calculateAngle(first: CGPoint, center: CGPoint, second: CGPoint) -> Float {
        
//        let a = CGPoint(x: center.x - first.x, y: center.y - first.y)
//        let b = CGPoint(x: center.x - second.x, y: center.y - second.y)
//
//        double crossAngle = atan2(second.y - center.y, second.x - center.x) -
//                            atan2(first.y - center.y, first.x - center.x);
//
//        print(crossAngle)
        return 0.0
    }
    
}




extension Array <CGPoint?> {
    func returnNotNil() -> [CGPoint]{
        return self.compactMap({ $0 })
    }
}

