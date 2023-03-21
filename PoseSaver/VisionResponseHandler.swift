//
//  VisionResponseHandler.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/16/23.
//

import Foundation
import Vision

class VisionResponseHandler {
    
    var handler: ([CGPoint]) -> Void
    var joints: [VNHumanBodyPoseObservation.JointName : CGPoint] = [:]
    private let bodyPoseDetectionMinConfidence: VNConfidence = 0.6
    private let bodyPoseRecognizedPointMinConfidence: VNConfidence = 0.1
    
    lazy var responseHandler: (VNRequest, Error?) -> Void = {[self] (request, error) in
        
        guard let results = request.results else {
            print("----")
            return
        }
        guard let observations =
                request.results as? [VNHumanBodyPoseObservation] else {
            return
        }
        
        observations.forEach{self.processObservation($0)}
    }
    
    
    init(handler: @escaping ([CGPoint]) -> Void) {
        self.handler = handler
    }
    
   func processObservation(_ observation: VNHumanBodyPoseObservation) {
        
        // Retrieve all torso points.
        guard let recognizedPoints =
                try? observation.recognizedPoints(.all) else { return }
        
        // all the joints
        let torsoJointNames: [VNHumanBodyPoseObservation.JointName] = [
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
       let displayPoints = recognizedPoints.map {
           CGPoint(x: $0.value.x, y: 1 - $0.value.y)
       }

       self.handler(displayPoints)
    }
}
