//
//  ViewController.swift
//  Urmove
//
//  Created by Christian on 5/5/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import Firebase
import EZAlertController
import Alertift
class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    var userData: customer?
    var userAccount: Bool?
    var userCollection: CollectionReference!
    var userRef: DocumentReference!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton.loginBehavior = .web
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        // Do any additional setup after loading the view, typically from a nib.
        FBSDKLoginManager().logOut()
        if let accessToken = AccessToken.current{
            print(accessToken.userId)
            
            print("logged in already")
            self.performSegue(withIdentifier: "authenticated", sender: self)
            
            
        }else{
            FBSDKLoginManager().logOut()
        }
    }
    // Firestore
    func docFacebookUserFinder(userID: String, userName: String, displayName: String ){
        let db = Firestore.firestore()
        userRef = db.collection("users").document(userID)
        userCollection = db.collection("users")
        userRef.getDocument { (document, error) in
            
            if (document?.exists)!{
                self.userAccount = true
                let loggedInUserData = customer()
                let postDict = document?.data()
                let displayName = postDict!["displayName"] as? String?
                let userID = postDict!["userID"] as? String?
                let userName = postDict!["userName"] as? String?
                //referrals
                
                
                
                self.performSegue(withIdentifier: "authenticated", sender: self)
                print(postDict!["name"]) as? String
            }else{
                self.userAccount = false
                print("aint shit here")
                EZAlertController.alert("EULA", message: "By signing in using a social media account you agree to Apple's EULA and ADNAP's EULA. By Signing in you have the ability to participate in event specific chat rooms and our general chat rooms. We do not allow offensive or abusive messages. If you see any offensive or abusive messages, use our contact to form to report them and we will take action accordingly", buttons: ["Accept", "Decline"]) {(alertAction, position) -> Void in
                    if position == 0 {
                        print("Accepted")
                        let newUser = ["userName": userName,
                                       "userID":userID,
                                       "displayName":displayName,
                                       "blockList": [Any]()
                            
                            ] as [String : Any]
                        self.userRef.setData(newUser)
                        let loggedInUserData = customer()
                    
                        self.userData = loggedInUserData
                        self.performSegue(withIdentifier: "authenticated", sender: self)
                        
                    }else if position == 1 {
                        print("Cencelled")
                        FBSDKLoginManager().logOut()
                    }
                }
            }
            
        }
        
        
        
        
    }
    func docUserFinder(userID: String){
        let db = Firestore.firestore()
        userRef = db.collection("users").document(userID)
        userRef.getDocument { (document, error) in
            if let document = document {
                self.userAccount = true
                let loggedInUserData = customer()
                let dict = document.data()
               
                
              
                
                
                self.userData = loggedInUserData
                self.performSegue(withIdentifier: "authenticated", sender: self)
                
            }else {
                self.userAccount = false
                print("nothing here")
            }
        }
        
    }
    // LOGIN FUNCTIONS
    //login functions
    func facebookLoginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, ReadPermission.email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("user cancelled login")
            case .success(let grantedPermissions, let declinePermissions, let accessToken):
                print("Logged in")
            }
        }
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error{
            print(error.localizedDescription)
            return
        }else{
            let accessToken = FBSDKAccessToken.current()
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }else{
                    print(user?.uid)
                    self.docFacebookUserFinder(userID: (user?.uid)!,userName: (user?.displayName)!, displayName: (user?.displayName)!)
                    
                    
                    
                   
                }
            })
            
        }
    }
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("loggedout")
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
        }catch let signOutError as NSError{
            
            print("error", signOutError)
        }
    }
    @IBAction func signInFunc(_ sender: Any) {
        let email = usernameTextField.text
        let password = passwordTextField.text
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if let error = error{
                Alertift.alert(title: "Error", message: error.localizedDescription).action(.default("OK")).show(on: self)
                print(error)
            }else{
                //self.userFinder(userID: (user?.uid)!, email: (user?.email)!)
               
                    self.docUserFinder(userID: (user?.uid)!)
                    
                    
                
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

