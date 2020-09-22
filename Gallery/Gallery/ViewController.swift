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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

    }
}
