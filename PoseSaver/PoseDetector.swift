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

protocol PoseDetector {
    func perfromDtection(sourceImage: CGImage, completionHandler:(PoseDetectionRseponse) -> Void )
    
}

struct PoseDetectionRseponse {
    var connectedJoints: [Joint]
}

struct Joint {
    var jointPoints : [String : [CGPoint]]
    
}






class OfficePoseDetector {
    
    
    func processImage(cgImage: CGImage, handler: @escaping ([[CGPoint]]) -> Void){
        //create vision request
        let responseHandler = VisionResponseHandler(){ joints in
            
            let neckLine: [CGPoint?] = [joints[.leftShoulder] ?? nil, joints[.neck] ?? nil, joints[.rightShoulder] ?? nil]
            let spine: [CGPoint?] = [joints[.root] ?? nil, joints[.neck] ?? nil]
            let leftLeg: [CGPoint?] = [joints[.leftHip] ?? nil, joints[.leftKnee] ?? nil, joints[.leftAnkle] ?? nil]
            let rightLeg: [CGPoint?] = [joints[.rightHip] ?? nil, joints[.rightKnee] ?? nil, joints[.rightAnkle] ?? nil]
            let rightHand: [CGPoint?] = [joints[.rightShoulder] ?? nil, joints[.rightElbow] ?? nil, joints[.rightWrist] ?? nil]
            let leftHand: [CGPoint?] = [joints[.leftShoulder] ?? nil, joints[.leftElbow] ?? nil, joints[.leftWrist] ?? nil]
            let waistLine: [CGPoint?] = [joints[.leftHip] ?? nil, joints[.root] ?? nil, joints[.rightHip] ?? nil]
            
            handler([neckLine.returnNotNil(), spine.returnNotNil(), rightLeg.returnNotNil(), leftLeg.returnNotNil(), leftHand.returnNotNil(), rightHand.returnNotNil(), waistLine.returnNotNil()])
        }
        var visionRequestBuilder = VisionRequestBuilder(sourceImage: cgImage, completionHandler: responseHandler.responseHandler)
        visionRequestBuilder.performDetection()
    }
    
    private func validatePose() -> Error? {
        
    }
    
    
}


extension Array <CGPoint?> {
    func returnNotNil() -> [CGPoint]{
        return self.compactMap({ $0 })
    }
}
