//
//  AppDelegate.swift
//  Gallery
//
//  Created by CY on 2020/05/14.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift
//import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
//        GIDSignIn.sharedInstance().clientID = "936286010895-vqkmqr183ekitsbag1gg684j5bg7rjqa.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self
        
        //facebook
//        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    //facebook
//    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
//        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] ) } }
//
//
//
    
    
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//                withError error: Error!) {
//        if let error = error {
//          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//            print("The user has not signed in before or they have since signed out.")
//          } else {
//            print("\(error.localizedDescription)")
//          }
//          // [START_EXCLUDE silent]
//          NotificationCenter.default.post(
//            name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
//          // [END_EXCLUDE]
//          return
//        }
//        
//        
//      func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
//                withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // [START_EXCLUDE]
//        NotificationCenter.default.post(
//          name: Notification.Name(rawValue: "ToggleAuthUINotification"),
//          object: nil,
//          userInfo: ["statusText": "User has disconnected."])
//        // [END_EXCLUDE]
//      }
//      // [END disconnect_handler]
//    }

}



    
