//
//  ViewController.swift
//  TaxiCall
//
//  Created by YU on 2018/10/12.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var userModelSwitch: UISwitch!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var buttonOutlet: UIButton!
   
    
    @IBAction func signInButton(_ sender: UIButton) {
        
        if email.text != "" && password.text != "" {
            
            authService(mail: email.text!, pwd: password.text!)
            
        } else {
            
            print("Please entry your email and password")
            displayAlert(title: "登入錯誤", message: "請重新輸入帳號或密碼")
            
        }
    }
    
    func authService(mail: String, pwd: String) {
        
        Auth.auth().signIn(withEmail: mail, password: pwd) { (user, error) in
            
            if error != nil {
                
                //得到user_not_foound 判斷用戶不存在
                //print((error as! NSError).userInfo["error_name"]!)
                print(error)
                
                let errorString = String(describing: (error as! NSError).userInfo["error_name"]!)
                
                if errorString == "ERROR_USER_NOT_FOUND" {
                    
                    Auth.auth().createUser(withEmail: mail, password: pwd) { (user, error) in
                        
                        if error != nil {
                            
                            print(error)
                            self.displayAlert(title: "創建錯誤", message: (error?.localizedDescription)!)
                        } else {
                            
                            print("User created")
                            
                        }
                    }
                    
                } else {
                    
                    //print(error)
                    self.displayAlert(title: "登入錯誤", message: (error?.localizedDescription)!)
                }
                
               
    
            } else {
                
                print("User already sign in")
                
            }
        }
    
    }
    func displayAlert(title: String, message: String) {
        let alertcontorller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alertcontorller.addAction(alertAction)
        
        self.present(alertcontorller, animated: true, completion: nil)
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

