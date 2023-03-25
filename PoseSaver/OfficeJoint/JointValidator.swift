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
    
    func createJointLine(name: JointGroup, points: [VNHumanBodyPoseObservation.JointName : CGPoint?]) -> JointLine? {
        switch name{
            
        case .leftHand:
            guard let leftShoulder = points[.leftShoulder] else{
               return nil
            }
            guard let leftElbow = points[.leftElbow] else{
                return nil
            }
            guard let leftWrist = points[.leftWrist] else{
                return nil
            }
            let angle = calculateAngle(p0: leftShoulder!, c: leftElbow!, p1: leftWrist!)
            
            print("left hand angle -> \(angle)")
            if angle < 80 || angle > 100
            {
                return JointLine(name: name.rawValue, jointPoints: [leftShoulder, leftElbow, leftWrist], error: .WRONG_ELBOW_ANGLE)
            }else{
                return JointLine(name: name.rawValue, jointPoints: [leftShoulder, leftElbow, leftWrist], error: nil)
            }
            
            
        case .rightHand:
            guard let shoulder = points[.rightShoulder] else{
                return nil
                
            }
            guard let elbow = points[.rightElbow] else{
                return nil
            }
            guard let wrist = points[.rightWrist] else{
                return nil
            }
            
            let angle = calculateAngle(p0: shoulder!, c: elbow!, p1: wrist!)
            
            print("left hand angle -> \(angle)")
            if angle < 80 || angle > 100
            {
                return JointLine(name: name.rawValue, jointPoints: [shoulder, elbow, wrist], error: .WRONG_ELBOW_ANGLE)
            }else{
                return JointLine(name: name.rawValue, jointPoints: [shoulder, elbow, wrist], error: nil)
            }
            
        case .leftLeg:
            guard let hip = points[.leftHip] else{
               return nil
            }
            guard let knee = points[.leftKnee] else{
                return nil
            }
            guard let ankle = points[.leftAnkle] else{
                return nil
            }
            let angle = calculateAngle(p0: hip!, c: knee!, p1: ankle!)
            
            print("left knee angle -> \(angle)")
            if angle < 80 || angle > 100
            {
                return JointLine(name: name.rawValue, jointPoints: [hip, knee, ankle], error: .WRONG_KNEE_ANGLE)
            }else{
                return JointLine(name: name.rawValue, jointPoints: [hip, knee, ankle], error: nil)
            }
            
            
        case .rightLeg:
            guard let hip = points[.rightHip] else{
                return nil
            }
            guard let knee = points[.rightKnee] else{
                return nil
            }
            guard let ankle = points[.rightAnkle] else{
                return nil
            }
            
            let angle = calculateAngle(p0: hip!, c: knee!, p1: ankle!)
            print("right Knee angle -> \(angle)")
        
            if angle < 80 || angle > 100
            {
                return JointLine(name: name.rawValue, jointPoints: [hip, knee, ankle], error: .WRONG_KNEE_ANGLE)
            }else{
                return JointLine(name: name.rawValue, jointPoints: [hip, knee, ankle], error: nil)
            }
            
        default:
            let values = points.values.compactMap { point in
                point
            }
            
            return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            
        }
    }
    
    func calculateAngle(p0: CGPoint, c: CGPoint, p1: CGPoint) -> CGFloat {
        let p0c = sqrt(pow(c.x-p0.x,2) + pow(c.y-p0.y,2)); // p0->c (b)
        let p1c = sqrt(pow(c.x-p1.x,2) + pow(c.y-p1.y,2)); // p1->c (a)
        let p0p1 = sqrt(pow(p1.x-p0.x,2) + pow(p1.y-p0.y,2)); // p0->p1 (c)
        return acos((p1c*p1c+p0c*p0c-p0p1*p0p1)/(2*p1c*p0c)) * 180/Double.pi
    }
    
}




extension Array <CGPoint?> {
    func returnNotNil() -> [CGPoint]{
        return self.compactMap({ $0 })
    }
}

