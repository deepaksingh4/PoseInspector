//
//  VisionResponseHandler.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/16/23.
//

import Foundation
import Vision

class VisionResponseHandler {
    
    var handler: ([VNHumanBodyPoseObservation.JointName : CGPoint]) -> Void
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
    
    
    init(handler: @escaping ([VNHumanBodyPoseObservation.JointName: CGPoint]) -> Void) {
        self.handler = handler
    }
    
   func processObservation(_ observation: VNHumanBodyPoseObservation) {
        
        // Retrieve all torso points.
        guard let recognizedPoints =
                try? observation.recognizedPoints(.all) else { return }
        
        // all the joints
        
       let displayPoints = recognizedPoints.map {
           return [$0.key : CGPoint(x: $0.value.x, y: 1 - $0.value.y)]
       }
       
       var response : [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]
       recognizedPoints.forEach {
           response[$0.key] = CGPoint(x: $0.value.x, y: 1 - $0.value.y)
       }

       self.handler(response)
    }
}
