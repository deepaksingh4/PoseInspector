//
//  VideoCapture.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/15/23.
//

import Foundation
import AVFoundation
import CoreImage
import UIKit


protocol VideoCaptureDelegate {
    func capturedFrame(cgImage: CGImage)
    func foundJoints(points: [CGPoint])
}

class VideoCapture: NSObject{
    
    var delegate: VideoCaptureDelegate
    private var captureSession = AVCaptureSession()
    private var outPutData = AVCaptureVideoDataOutput()
    private static let overlayView = JointsOverLayView()
    private var overlayLayer = overlayView.previewOverlayLayer
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
        preview.videoGravity = .resizeAspectFill
        return preview
    }()
    
    init(delegate: VideoCaptureDelegate){
        self.delegate = delegate
        super.init()
        addCameraInput()
        addCameraOutput()
    }
    
    
    func addCameraInput(){
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else{
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            self.captureSession.addInput(cameraInput)
        }catch{
            print("Exception while gaining access")
        }
        
    }
    
    func addCameraOutput(){
        self.outPutData.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.outPutData.setSampleBufferDelegate(self, queue: DispatchQueue(label: "my.image.handling.queue"))
        self.captureSession.addOutput(outPutData)
    }
    
    func getPreviewLayer() -> AVCaptureVideoPreviewLayer {
        previewLayer.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        
        return previewLayer
    }
    func startCapture(){
        self.previewLayer.addSublayer(overlayLayer)
        DispatchQueue.global(qos: .utility).async{
            self.captureSession.startRunning()
        }
        
    }
    
    func stopCapture(){
        self.captureSession.stopRunning()
    }
    
    func updatePreviewFrame(rect: CGRect){
        self.previewLayer.frame = rect
    }
}


extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let poseDetector = OfficePoseDetector()
        poseDetector.processBuffer(sampleBuffer: sampleBuffer) {[weak self] jointLines in
            VideoCapture.overlayView.joints = jointLines.map({ jointLine in
                var joint = jointLine
                guard let self = self else{
                    return JointLine(name: "Invalid", jointPoints: [])
                }
                joint.updatePointForPreviewLayer(previewLayer: self.previewLayer)
                return joint
            })
        }
    }
    
    private func convert(cmage: CIImage) -> CGImage {
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(cmage, from: cmage.extent)!
        return cgImage
    }
    
    private func convertToPreviewPoints(points: [CGPoint]) -> [CGPoint]{
        points.map { point in
            return self.previewLayer.layerPointConverted(fromCaptureDevicePoint: point)
        }
    }
}
