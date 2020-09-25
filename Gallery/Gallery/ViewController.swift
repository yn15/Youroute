//
//  ViewController.swift
//  TEST_FIREBASE
//
//  Created by mac on 2020/06/10.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import GoogleSignIn



class ViewController: UIViewController {
    
@IBOutlet var signInButton : GIDSignInButton!
// email sign in1
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "YouRoute Log In"
        label.font = .systemFont(ofSize:24, weight :.semibold )
        return label
        }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.layer.backgroundColor = UIColor.white.cgColor
        return emailField
    }()
    
    private let passField: UITextField = {
        let passField  = UITextField()
        passField.placeholder = "Password"
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.backgroundColor = UIColor.white.cgColor
        return passField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for : .normal)
           return button
       }()
// email sign in 1 end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // googleSign in
       
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // email sign in
        
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passField)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 80)
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width - 40,
                                  height: 50)
         
        passField.frame = CGRect(x: 20,
                                 y: emailField.frame.origin.y+emailField.frame.size.height+10,
                                 width: view.frame.size.width - 40,
                                 height: 50)
        button.frame = CGRect(x: 20,
                              y: passField.frame.origin.y+passField.frame.size.height+10,
                              width: view.frame.size.width - 40 ,
                              height: 80)
        
    }
    
    @objc private func didTapButton(){
        print("Continue button tap")
        
    }
}
