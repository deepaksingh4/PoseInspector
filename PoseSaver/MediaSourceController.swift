//
//  MediaSourceController.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/14/23.
//

import Foundation
import UIKit
import AVFoundation

class MediaSourceController: UIViewController {
    
    var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    let overlayView = JointsOverLayView()
    var inputSource: InputSource = .LiveCamera
    //    var selectedImage: UIImage?
    private lazy var videoCapture: VideoCapture = {
        return VideoCapture(delegate: self)
    }()
    
    override func didMove(toParent parent: UIViewController?) {
        if let parent = parent as? MainViewController {
            parent.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if inputSource == .LiveCamera{
            videoCapture.startCapture()
            startCamera()
        }else{
            captureImage()
        }
    }
    
    func captureImage(){
        videoCapture.getPreviewLayer().removeFromSuperlayer()
        videoCapture.stopCapture()
        
        overlayView.previewOverlayLayer.frame = self.view.frame
        self.view.layer.addSublayer(overlayView.previewOverlayLayer)
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoCapture.updatePreviewFrame(rect: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    }
    
    func startCamera(){
        self.view.layer.addSublayer(videoCapture.getPreviewLayer())
    }
}


extension MediaSourceController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("So new")
        guard let originalImage = info[.originalImage] as? UIImage else{
            return
        }
        let imgView = UIImageView(frame: self.view.bounds)
        imgView.image = originalImage
        imgView.center = self.view.center
        imgView.contentMode = .scaleAspectFill
        self.view.addSubview(imgView)
        let poseDetector = OfficePoseDetector()
        poseDetector.processImage(cgImage: originalImage.cgImage!) {[weak self] jointLines in

            self?.overlayView.joints = jointLines.map({ jointLine in
                let joint = jointLine
                guard self != nil else{
                    return JointLine(name: "Invalid", jointPoints: [])
                }
                //                joint.updatePointForPreviewLayer(previewLayer: self.previewLayer)
                return joint
            })
        }
        self.dismiss(animated: true)
    }
    
    
}

extension MediaSourceController: InputSourceDelegate{
    func inputUpdated(inputSource: InputSource) {
        if inputSource == .LiveCamera{
            videoCapture.startCapture()
            startCamera()
        }else{
            captureImage()
        }
    }
}


extension MediaSourceController: VideoCaptureDelegate{
    
    func capturedFrame(cgImage: CGImage) {
        //        let poseDetector = PoseDetector()
        //        poseDetector.processImage(cgImage: cgImage) {[weak self] points in
        //            points.forEach { point in
        //
        //                //tranfrom point
        //                let circlePath = UIBezierPath(arcCenter: point, radius: CGFloat(3), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        //                guard let self = self else {
        //                    return
        //                }
        //
        //                let shapeLayer = CAShapeLayer()
        //                shapeLayer.path = circlePath.cgPath
        //
        //                // Change the fill color
        //                shapeLayer.fillColor = UIColor.red.cgColor
        //                // You can change the stroke color
        //                shapeLayer.strokeColor = UIColor.white.cgColor
        //                // You can change the line width
        //                shapeLayer.lineWidth = 2.0
        //                DispatchQueue.main.async {
        //                    self.view.layer.addSublayer(shapeLayer)
        //                }
        //            }
        //
        //        }
    }
    
    func foundJoints(points: [CGPoint]) {
        
    }
    
}
