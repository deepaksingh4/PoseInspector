//
//  VisionResponseHandler.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/16/23.
//

import Foundation
import Vision

struct VisionResponseHandler {
    static var responseHandler: (VNRequest, Error?) -> Void = { (request, error) in
        
        guard let results = request.results else {
            print("----")
            return
        }
        print(results.count)
        guard let observations =
                   request.results as? [VNHumanBodyPoseObservation] else {
               return
           }
        print(observations.count)
        observations.forEach{processObservation($0)}
    }
    
   static func processObservation(_ observation: VNHumanBodyPoseObservation) {
        
        // Retrieve all torso points.
        guard let recognizedPoints =
                try? observation.recognizedPoints(.torso) else { return }
        
        // Torso joint names in a clockwise ordering.
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
        
        // Retrieve the CGPoints containing the normalized X and Y coordinates.
        let imagePoints: [CGPoint] = torsoJointNames.compactMap {
            guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
            let pointImg = VNImagePointForNormalizedPoint(point.location,
                                                  Int(screenWidth),
                                                  Int(screenHeight))
            print("\($0) ---> \(point)")
            // Translate the point from normalized-coordinates to image coordinates.
            return pointImg
        }
       
        // Draw the points onscreen.
//        draw(points: imagePoints)
    }
}
