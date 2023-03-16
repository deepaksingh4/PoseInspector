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
    func processImage(cgImage: CGImage){
        //create vision request
        var visionRequestBuilder = VisionRequestBuilder(sourceImage: cgImage, completionHandler: VisionResponseHandler.responseHandler)
        visionRequestBuilder.performDetection()
        //proceess the requset
        //get  ressponse
    }
    

}
