//
//  MainViewController.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/13/23.
//

import UIKit

enum InputSource: Int {
    case LiveCamera
    case Photos
}

protocol InputSourceDelegate{
    func inputUpdated(inputSource: InputSource)
}

class MainViewController: UIViewController {
    var delegate: InputSourceDelegate?
    var inputSource: InputSource = .LiveCamera
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func updateSource(_ sender: UISegmentedControl) {
        inputSource = InputSource(rawValue: sender.selectedSegmentIndex)!
        delegate?.inputUpdated(inputSource: inputSource)
        
    }
    
}

