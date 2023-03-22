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
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else{
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
        let image = convert(cmage: ciImage)
        let poseDetector = PoseDetector()
        poseDetector.processImage(cgImage: image) {[weak self] points in
            VideoCapture.overlayView.joints = points.map({ posePoints in
                return self?.convertToPreviewPoints(points: posePoints) ?? []
            })
//            var path = CGMutablePath()
//            points.forEach { point in
//                //tranfrom point
//                let circlePath = UIBezierPath(arcCenter: self?.previewLayer.layerPointConverted(fromCaptureDevicePoint: point) ?? .zero, radius: CGFloat(5), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
//                path.addPath(circlePath.cgPath)
//            }
//            self?.overlayLayer.path = path
//
//            // Change the fill color
//            self?.overlayLayer.fillColor = UIColor.red.cgColor
//            // You can change the stroke color
//            self?.overlayLayer.strokeColor = UIColor.white.cgColor
//            // You can change the line width
//            self?.overlayLayer.lineWidth = 2.0
//            DispatchQueue.main.async {
//                self?.overlayLayer.didChangeValue(forKey: "path")
//            }
            
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
