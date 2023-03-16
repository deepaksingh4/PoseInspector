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
    }
}
