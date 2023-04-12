//
//  AlertViewController.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 10.04.2023.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet var uyariLabel: UILabel!
    @IBOutlet var okeyButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var busImageContainerView: UIView!
    
    var textMessage:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.borderColor = CGColor(red: 0, green: 31/255, blue: 91/255, alpha: 1)
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 8
        
        busImageContainerView.layer.borderColor = CGColor(red: 0, green: 31/255, blue: 91/255, alpha: 1)
        busImageContainerView.layer.borderWidth = 2
        busImageContainerView.layer.cornerRadius = 8
        
        okeyButton.layer.cornerRadius = 8
        
        uyariLabel.text = textMessage
    }

    @IBAction func okeyBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
}
