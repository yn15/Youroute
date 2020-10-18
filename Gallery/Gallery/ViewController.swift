import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase


class ViewController: UIViewController {
    
    @IBOutlet weak var backimage: UIImageView!
    @IBOutlet var signInButton : GIDSignInButton!
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "YouRoute Log In"
        label.font = .systemFont(ofSize:24, weight :.semibold)
        return label
        }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = " Email Address"
        emailField.layer.borderWidth = 1
        emailField.layer.backgroundColor = UIColor.white.cgColor
        return emailField
    }()
    
    private let passField: UITextField = {
        let passField  = UITextField()
        passField.placeholder = " Password"
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.backgroundColor = UIColor.white.cgColor
        return passField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Continue", for : .normal)
           return button
       }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // googleSign in
       
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // email sign in
        
        view.addSubview(label)
        view.addSubview(emailField)
        view.addSubview(passField)
        view.addSubview(button)
        let naviBgImage = UIImage(named: "airplane-2588225_1280@3x.png")
        backimage.image = naviBgImage
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        label.frame = CGRect(x: 0, y: 60, width: view.frame.size.width, height: 80)
        emailField.frame = CGRect(x: 20,
                                  y: label.frame.origin.y+label.frame.size.height+10,
                                  width: view.frame.size.width - 40,
                                  height: 50)
         
        passField.frame = CGRect(x: 20,
                                 y: emailField.frame.origin.y+emailField.frame.size.height+10,
                                 width: view.frame.size.width - 40,
                                 height: 50)
        button.frame = CGRect(x: 20,
                              y: passField.frame.origin.y+passField.frame.size.height+100,
                              width: view.frame.size.width - 40 ,
                              height: 80)
        
    }
    
    @objc private func didTapButton(){
        print("Continue button tap")
        guard let email  = emailField.text, !email.isEmpty,
            let password = passField.text, !password.isEmpty else {
                print("Missing Field data")
                return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult, error in
            guard let strongSelf = self else{
                return
            }
            
            guard error == nil else {
                strongSelf.showCreateAccount(email: email, password: password)
                return
            }
            print("You have Sign In")
            strongSelf.label.isHighlighted = true
            strongSelf.emailField.isHighlighted = true
            strongSelf.passField.isHighlighted = true
            strongSelf.button.isHighlighted = true
            
            if let maincontroller = self?.storyboard?.instantiateViewController(identifier: "MainController") {
                self?.navigationController?.pushViewController(maincontroller, animated: true)
            }
        })
    }
    
    func showCreateAccount(email:String,password : String){
        let alert = UIAlertController(title: "Creat account",
                                      message: "Would you like to create an account",
                                      preferredStyle: .alert )
        
        alert.addAction(UIAlertAction(title:  "Continue",
                                      style: .default,
                                      handler: {_ in
                                        
                                        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authResult, error in
                                            
                                            guard let strongSelf = self else{
                                                    return
                                                }
                                                
                                                guard error == nil else {
                                                    //show account creation
                                                    print("Account create failed")
                                                    return
                                                }
                                                print("You have Sign In")
                                                strongSelf.label.isHighlighted = true
                                                strongSelf.emailField.isHighlighted = true
                                                strongSelf.passField.isHighlighted = true
                                                strongSelf.button.isHighlighted = true
                                                
                                            })

        }))
        alert.addAction(UIAlertAction(title:  "Cancel",
                                      style: .cancel,
                                      handler: {_ in
                                        
        }))
        present(alert, animated: true)
    }
}
