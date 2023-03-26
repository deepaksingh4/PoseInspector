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
import AVFoundation

protocol PoseDetector {
    func perfromDtection(sourceImage: CGImage, completionHandler:([JointLine]) -> Void )
    
}

enum SittingPostureError: Error {
    case WRONG_ELBOW_ANGLE
    case WRONG_KNEE_ANGLE
}

struct JointLine {
    var name: String
    var jointPoints : [CGPoint?]
    var error: SittingPostureError?
    
    mutating func updatePointForPreviewLayer(previewLayer: AVCaptureVideoPreviewLayer){
        jointPoints = jointPoints.compactMap({$0}).map { point in
            previewLayer.layerPointConverted(fromCaptureDevicePoint: point)
        }
    }
}


enum JointGroup: String {
    case neckLine
    case waistLine
    case leftHand
    case rightHand
    case leftLeg
    case rightLeg
    case spine
}





class OfficePoseDetector {
    
    
    func processBuffer( sampleBuffer: CMSampleBuffer, handler: @escaping ([JointLine]) -> Void){
        //create vision request
        let responseHandler = VisionResponseHandler(){ joints in
            
//            let neckLine: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder :  joints[.leftShoulder] ?? nil, .neck: joints[.neck] ?? nil,.rightShoulder: joints[.rightShoulder] ?? nil]
            let spine: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder : joints[.root] ?? nil, .neck: joints[.neck] ?? nil]
            let leftLeg: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftHip: joints[.leftHip] ?? nil,.leftKnee: joints[.leftKnee] ?? nil,.leftAnkle: joints[.leftAnkle] ?? nil]
            let rightLeg: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.rightHip: joints[.rightHip] ?? nil, .rightKnee: joints[.rightKnee] ?? nil,.rightAnkle: joints[.rightAnkle] ?? nil]
            let rightHand: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.rightShoulder: joints[.rightShoulder] ?? nil,.rightElbow: joints[.rightElbow] ?? nil, .rightWrist: joints[.rightWrist] ?? nil]
            let leftHand: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder: joints[.leftShoulder] ?? nil,.leftElbow: joints[.leftElbow] ?? nil,.leftWrist: joints[.leftWrist] ?? nil]
//            let waistLine: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftHip: joints[.leftHip] ?? nil,.root: joints[.root] ?? nil,.rightHip: joints[.rightHip] ?? nil]
            
            let jointValidator = JointValidator()
            handler(
                [jointValidator.createJointLine(name: .leftHand, points: leftHand) ?? nil,
                 jointValidator.createJointLine(name: .leftLeg, points: leftLeg) ?? nil,
                 jointValidator.createJointLine(name: .rightLeg, points: rightLeg) ?? nil,
                 jointValidator.createJointLine(name: .rightHand, points: rightHand) ?? nil,
                 jointValidator.createJointLine(name: .spine, points: spine) ?? nil].compactMap({ $0 })
            )
        }
        var visionRequestBuilder = VisionRequestBuilder(sampleBuffer: sampleBuffer, completionHandler: responseHandler.responseHandler)
        visionRequestBuilder.performDetection()
    }
    
    func processImage(cgImage: CGImage,handler: @escaping ([JointLine]) -> Void){
        let responseHandler = VisionResponseHandler(){ joints in
            
//            let neckLine: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder :  joints[.leftShoulder] ?? nil, .neck: joints[.neck] ?? nil,.rightShoulder: joints[.rightShoulder] ?? nil]
            let spine: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder : joints[.root] ?? nil, .neck: joints[.neck] ?? nil]
            let leftLeg: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftHip: joints[.leftHip] ?? nil,.leftKnee: joints[.leftKnee] ?? nil,.leftAnkle: joints[.leftAnkle] ?? nil]
            let rightLeg: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.rightHip: joints[.rightHip] ?? nil, .rightKnee: joints[.rightKnee] ?? nil,.rightAnkle: joints[.rightAnkle] ?? nil]
            let rightHand: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.rightShoulder: joints[.rightShoulder] ?? nil,.rightElbow: joints[.rightElbow] ?? nil, .rightWrist: joints[.rightWrist] ?? nil]
            let leftHand: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder: joints[.leftShoulder] ?? nil,.leftElbow: joints[.leftElbow] ?? nil,.leftWrist: joints[.leftWrist] ?? nil]
            
            let jointValidator = JointValidator()
            handler(
                [jointValidator.createJointLine(name: .leftHand, points: leftHand) ?? nil,
                 jointValidator.createJointLine(name: .leftLeg, points: leftLeg) ?? nil,
                 jointValidator.createJointLine(name: .rightLeg, points: rightLeg) ?? nil,
                 jointValidator.createJointLine(name: .rightHand, points: rightHand) ?? nil,
                 jointValidator.createJointLine(name: .spine, points: spine) ?? nil].compactMap({ $0 })
            )
        }
        var visionRequestBuilder = VisionRequestBuilder(sourceImage: cgImage, completionHandler: responseHandler.responseHandler)
        visionRequestBuilder.performImageDetection()
    }
    
}



