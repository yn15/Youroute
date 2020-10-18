import UIKit
import GoogleSignIn
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = "936286010895-vqkmqr183ekitsbag1gg684j5bg7rjqa.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        GMSServices.provideAPIKey("AIzaSyB_nErUVkzvyiKPAJS4TMGQKjVdUNmmv0M")
        GMSPlacesClient.provideAPIKey("AIzaSyB_nErUVkzvyiKPAJS4TMGQKjVdUNmmv0M")
        
        let db = Firestore.firestore()
        return true
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
        print("User email: \(user.profile.email ?? "No Email")")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

            return GIDSignIn.sharedInstance().handle(url)
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

 
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
    

    
}
