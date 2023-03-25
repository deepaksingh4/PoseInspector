//
//  AlertViews.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/25/23.
//

import Foundation
import UIKit



class Alerts{
    
    static let shared : Alerts = Alerts()
    
    private init(){
        
    }
    
    private lazy var alertView: AlertView = {
        return  AlertView(frame: CGRect(x: 0, y: 40, width: 300, height: 100))
    }()
    
    func hideAlert(){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.view.subviews.filter { view in
                return view.tag == 1221
            }.forEach { alertView in
                alertView.removeFromSuperview()
            }
        }
    }
    
    func showErrorView(message: String){

        DispatchQueue.main.async {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.view.subviews.filter { view in
                    return view.tag == 1221
                }.forEach { alertView in
                    alertView.removeFromSuperview()
                }
                
                
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
        
                self.alertView.translatesAutoresizingMaskIntoConstraints = false
                self.alertView.tag = 1221
                self.alertView.setMesage(message: message)
                topController.view.insertSubview(self.alertView, aboveSubview: topController.view)
                self.alertView.heightAnchor.constraint(equalToConstant: 100).isActive = true
                self.alertView.centerXAnchor.constraint(equalTo: topController.view.centerXAnchor).isActive = true
                self.alertView.widthAnchor.constraint(equalTo: topController.view.widthAnchor, multiplier: 0.8).isActive = true
                self.alertView.bottomAnchor.constraint(equalTo: topController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10){
            self.hideAlert()
        }

    }
}
