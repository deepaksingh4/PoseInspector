//
//  VideoCapture.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/15/23.
//

import Foundation
import AVFoundation
import CoreImage


protocol VideoCaptureDelegate {
    func capturedFrame(cgImage: CGImage)
}

class VideoCapture: NSObject{
    
    var delegate: VideoCaptureDelegate
    private var captureSession = AVCaptureSession()
    private var outPutData = AVCaptureVideoDataOutput()
    
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
        guard let device = AVCaptureDevice.default(for: .video) else{
            return
        }
        do {
            let cameraInput = try AVCaptureDeviceInput(device: device)
            self.captureSession.addInput(cameraInput)
            print("added input")
        }catch{
            print("Exception")
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
        delegate.capturedFrame(cgImage: image)
    }
    
    func convert(cmage: CIImage) -> CGImage {
         let context = CIContext(options: nil)
         let cgImage = context.createCGImage(cmage, from: cmage.extent)!
         return cgImage
    }
}
