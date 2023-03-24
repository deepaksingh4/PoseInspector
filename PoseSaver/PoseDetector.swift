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
    
    
    func processImage(cgImage: CGImage, handler: @escaping ([JointLine]) -> Void){
        //create vision request
        let responseHandler = VisionResponseHandler(){ joints in
            
            let neckLine: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder :  joints[.leftShoulder] ?? nil, .neck: joints[.neck] ?? nil,.rightShoulder: joints[.rightShoulder] ?? nil]
            let spine: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder : joints[.root] ?? nil, .neck: joints[.neck] ?? nil]
            let leftLeg: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftHip: joints[.leftHip] ?? nil,.leftKnee: joints[.leftKnee] ?? nil,.leftAnkle: joints[.leftAnkle] ?? nil]
            let rightLeg: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.rightHip: joints[.rightHip] ?? nil, .rightKnee: joints[.rightKnee] ?? nil,.rightAnkle: joints[.rightAnkle] ?? nil]
            let rightHand: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.rightShoulder: joints[.rightShoulder] ?? nil,.rightElbow: joints[.rightElbow] ?? nil, .rightAnkle: joints[.rightWrist] ?? nil]
            let leftHand: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftShoulder: joints[.leftShoulder] ?? nil,.leftElbow: joints[.leftElbow] ?? nil,.leftWrist: joints[.leftWrist] ?? nil]
            let waistLine: [VNHumanBodyPoseObservation.JointName : CGPoint?] = [.leftHip: joints[.leftHip] ?? nil,.root: joints[.root] ?? nil,.rightHip: joints[.rightHip] ?? nil]
            
            let jointValidator = JointValidator()
            handler(
                [jointValidator.createJointLine(name: .leftHand, points: leftHand),
                jointValidator.createJointLine(name: .leftLeg, points: leftLeg),
                jointValidator.createJointLine(name: .neckLine, points: neckLine)]
            )
        }
        var visionRequestBuilder = VisionRequestBuilder(sourceImage: cgImage, completionHandler: responseHandler.responseHandler)
        visionRequestBuilder.performDetection()
    }
    
}


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
            
            
        default:
            let values = points.values.compactMap { point in
                point
            }
    
            return JointLine(name: name.rawValue, jointPoints: values, error: nil)
            
        }
    }

}




extension Array <CGPoint?> {
    func returnNotNil() -> [CGPoint]{
        return self.compactMap({ $0 })
    }
}
