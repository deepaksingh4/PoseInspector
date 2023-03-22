//
//  PoseDetector.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/16/23.
//

import Foundation
import CoreGraphics
import VisionKit
import Vision

class PoseDetector {
    
    let jointNames: [VNHumanBodyPoseObservation.JointName] = [
        .nose,
        .leftEye,
        .rightEye,
        .leftEar,
        .rightEar,
        .leftShoulder,
        .rightShoulder,
        .leftElbow,
        .rightElbow,
        .leftWrist,
        .rightWrist,
        .leftHip,
        .rightHip,
        .leftKnee,
        .rightKnee,
        .leftAnkle,
        .rightAnkle
    ]
    func processImage(cgImage: CGImage, handler: @escaping ([[CGPoint]]) -> Void){
        //create vision request
        let responseHandler = VisionResponseHandler(){ joints in
            var neckLine: [CGPoint] = []
            var spine: [CGPoint] = []
            var leftLeg: [CGPoint] = []
            var rightLeg: [CGPoint] = []
            var rightHand: [CGPoint] = []
            var leftHand: [CGPoint] = []
            
            
            
            joints.forEach { key,value in
                switch key{
                case .root,.rightHip, .rightKnee, .rightAnkle:
                    rightLeg.append(value)
                case .neck,.leftShoulder, .rightShoulder:
                    neckLine.append(value)
                case .root,.leftHip, .leftKnee, .leftAnkle:
                    leftLeg.append(value)
                case .rightShoulder, .rightElbow, .rightWrist:
                    rightHand.append(value)
                case .leftShoulder, .leftElbow, .leftWrist:
                    leftHand.append(value)
                case .neck, .root:
                    spine.append(value)
                default:
                    print("aa")
                }
            }
            handler([neckLine, spine, rightLeg, leftLeg, leftHand, rightHand])
        }
        var visionRequestBuilder = VisionRequestBuilder(sourceImage: cgImage, completionHandler: responseHandler.responseHandler)
        visionRequestBuilder.performDetection()
    }
    
    
    func validatePose(){
        
    }
    
    
    
    
    
    
    
    
    
    

}
