//
//  VisionRequestBuilder.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/16/23.
//

import Foundation
import Vision

struct VisionRequestBuilder {
    var imageBuffer: CMSampleBuffer?
    var sourceImage: CGImage?
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
    
    init(sourceImage: CGImage, completionHandler: @escaping VNRequestCompletionHandler){
        self.sourceImage = sourceImage
        self.completionHandler = completionHandler
    }
    
    mutating func performDetection(){
        do{
            guard let imageBuffer = imageBuffer else{
                return
            }
            try self.requestHandler.perform([request], on: imageBuffer)
        }catch{
            print("got exception")
        }
    }
    
    mutating func performImageDetection(){
        do{
            guard let sourceImage = sourceImage else{
                return
            }
            try self.requestHandler.perform([request], on: sourceImage)
        }catch{
            print("got exception")
        }
    }
    
}
