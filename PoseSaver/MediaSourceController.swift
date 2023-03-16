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
    
//    var selectedImage: UIImage?
    private lazy var videoCapture: VideoCapture = {
        return VideoCapture(delegate: self)
    }()
    
    override func viewDidLoad() {
        self.startCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        videoCapture.startCapture()
    }
    func captureImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
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
//        guard let originalImage = info[.originalImage] as? UIImage else{
//            return
//        }
//        selectedImage = originalImage
//        self.selectedImageView.image = selectedImage
//        self.dismiss(animated: true)
    }
    
    
}


extension MediaSourceController: VideoCaptureDelegate{
    func capturedFrame(cgImage: CGImage) {
        let poseDetector = PoseDetector()
        poseDetector.processImage(cgImage: cgImage)
    }
    
    
}
