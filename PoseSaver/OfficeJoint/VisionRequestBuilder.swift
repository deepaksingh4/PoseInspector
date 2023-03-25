//
//  VisionRequestBuilder.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/16/23.
//

import Foundation
import Vision

struct VisionRequestBuilder {
    var imageBuffer: CMSampleBuffer
    var completionHandler: VNRequestCompletionHandler
    var requestHandler = VNSequenceRequestHandler()
   
    private lazy var request: VNDetectHumanBodyPoseRequest = {
        let req = VNDetectHumanBodyPoseRequest(completionHandler: self.completionHandler)
        return req
    }()

    
    init( sampleBuffer: CMSampleBuffer, completionHandler: @escaping VNRequestCompletionHandler) {
        self.imageBuffer = sampleBuffer
        self.completionHandler = completionHandler
    }
    
    mutating func performDetection(){
        do{
            try self.requestHandler.perform([request], on: self.imageBuffer)
        }catch{
            print("got exception")
        }
    }
    
    
}
