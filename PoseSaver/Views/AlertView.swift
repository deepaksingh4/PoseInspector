//
//  AlertView.swift
//  PoseSaver
//
//  Created by Deepak Singh07 on 3/25/23.
//

import UIKit


class AlertView: UIView {
    @IBOutlet var contentview: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setMesage(message: String ){
        self.messageLabel.text = message
    }
    func commonInit(){
        Bundle.main.loadNibNamed("AlertView", owner: self)
        addSubview(contentview)
        self.beautify()
    }
    
    func beautify(){
        
        contentview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentview.frame = self.bounds

        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.init(named: "errorBackground")
    }

    @IBAction func userTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
