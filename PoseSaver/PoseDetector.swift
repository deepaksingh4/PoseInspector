//
//  PoseDetector.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/16/23.
//

import Foundation
import CoreGraphics
import VisionKit

class PoseDetector {
    func processImage(cgImage: CGImage, handler: @escaping ([CGPoint]) -> Void){
        //create vision reques
        let responseHandler = VisionResponseHandler(handler: handler)
        var visionRequestBuilder = VisionRequestBuilder(sourceImage: cgImage, completionHandler: responseHandler.responseHandler)
        visionRequestBuilder.performDetection()
        //proceess the requset
        //get  ressponse
    }
    
    
    
    
    
    
    
    
    
    
    

}
