//
//  ViewController.swift
//  TEST_FIREBASE
//
//  Created by mac on 2020/06/10.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    // 구글 버튼 연결 부분
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBAction func test(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // 페이스북 로긴 버튼
    class ViewController: UIViewController { override func viewDidLoad() { super.viewDidLoad(); let loginButton = FBLoginButton(); loginButton.center = view.center; view.addSubview(loginButton)
        loginButton.permissions = ["public_profile", "email"]
        }
        
    }

    
}
