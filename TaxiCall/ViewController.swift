//
//  ViewController.swift
//  TaxiCall
//
//  Created by YU on 2018/10/12.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userModelSwitch: UISwitch!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var buttonOutlet: UIButton!
   
    
    @IBAction func signInButton(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColor(customView: loginView, radius: 10)
        setColor(customView: buttonOutlet, radius: 10)
    }

    func setColor(customView : UIView, radius : CGFloat) {
        customView.layer.cornerRadius = radius
        customView.clipsToBounds = false
        
        setTextField(customTextField: email, iconName: "user")
        
        setTextField(customTextField: password, iconName: "pass")
    }
    
    func setTextField(customTextField : UITextField, iconName: String) {
        
        customTextField.leftViewMode = UITextField.ViewMode.always
        
        var iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        iconView.contentMode = UIView.ContentMode.scaleAspectFit
        iconView.image = UIImage(named: iconName)
        
        customTextField.leftView = iconView
        
        customTextField.borderStyle = UITextField.BorderStyle.line
        customTextField.layer.borderWidth = 1
        customTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
}

