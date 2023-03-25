//
//  VisionRequestBuilder.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/16/23.
//

import Foundation
import Vision

struct VisionRequestBuilder {
    var sourceImage: CGImage
    var completionHandler: VNRequestCompletionHandler
    lazy var reqHandler = VNImageRequestHandler(cgImage: self.sourceImage, orientation: .up)
    private lazy var request: VNDetectHumanBodyPoseRequest = {
        let req = VNDetectHumanBodyPoseRequest(completionHandler: self.completionHandler)
        return req
    }()

    
    init(sourceImage: CGImage, completionHandler: @escaping VNRequestCompletionHandler) {
        self.sourceImage = sourceImage
        
        self.completionHandler = completionHandler
    }
    
    mutating func performDetection(){
        do{
            try self.reqHandler.perform([self.request])
        }catch{
            print("got exception")
        }
    }
    
}
