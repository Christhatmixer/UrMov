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
    var userData = customer()
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
    func docFacebookUserFinder(userID: String, userName: String, displayName: String){
        let db = Firestore.firestore()
        userRef = db.collection("users").document(userID)
        userCollection = db.collection("users")
        userRef.getDocument { (document, error) in
            if let document = document{
                print(document.exists)
            }
            
            if (document?.exists)!{
                self.userAccount = true
                let loggedInUserData = customer()
                
                let dict = document?.data()
                let email = dict!["email"] as? String
                let firstName = dict!["firstName"] as? String
                let lastName = dict!["lastName"] as? String
                let authenticated = dict!["authenticated"] as? Bool
                let phoneNumber = dict!["phoneNumber"] as? String
                let userID = dict!["userID"] as? String
                
                self.userData.email = email
                self.userData.firstName = firstName
                self.userData.lastName = lastName
                self.userData.authenticated = authenticated
                self.userData.phoneNumber = phoneNumber
                self.userData.userID = userID
                
                print(self.userData.authenticated)
                
                if self.userData.authenticated == false{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "phoneVerification") as! PhoneVerificationViewController
                    vc.userData = self.userData
                    let navigation = UINavigationController(rootViewController: vc)
                    self.present(navigation, animated: true, completion: nil)
                }else{
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "carSelection") as! CarSelectionViewController
                    vc.userData = self.userData
                    self.present(vc, animated: true, completion: nil)
                    //let navigation = UINavigationController(rootViewController: vc)
                    //self.present(navigation, animated: true, completion: nil)
                    
                }
                
                
                
            }else{
                self.userAccount = false
                print("aint shit here")
                let newUser = ["userID":userID,
                               "firstName":displayName,
                               "authenticated": false
                    
                    ] as [String : Any]
                let newUserRef = Firestore.firestore().collection("users").document(userID)
                newUserRef.setData(newUser, completion: nil)
                let loggedInUserData = customer()
                loggedInUserData.userID = userID
                self.userData = loggedInUserData
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "carInfo") as! CarInfoViewController
                vc.userData = self.userData
                let navigation = UINavigationController(rootViewController: vc)
                navigation.navigationBar.isTranslucent = false
                navigation.navigationBar.barTintColor = UIColor(displayP3Red: 40.0/250, green: 39.0/250, blue: 46.0/250, alpha: 1.0)
                navigation.navigationBar.tintColor = UIColor(displayP3Red: 255.0/250, green: 174.0/250, blue: 66.0/250, alpha: 1.0)
                navigation.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)]
                navigation.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)]
                self.present(navigation, animated: true, completion: nil)
                
                //self.performSegue(withIdentifier: "authenticated", sender: self)
              
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
                let email = dict!["email"] as? String
                let firstName = dict!["firstName"] as? String
                let lastName = dict!["lastName"] as? String
                let authenticated = dict!["authenticated"] as? Bool
                let phoneNumber = dict!["phoneNumber"] as? String
                let userID = dict!["userID"] as? String
                
                self.userData.email = email
                self.userData.firstName = firstName
                self.userData.lastName = lastName
                self.userData.authenticated = authenticated
                self.userData.phoneNumber = phoneNumber
                self.userData.userID = userID
                
                
                
                if self.userData.authenticated == false{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "phoneVerification")
                    let navigation = UINavigationController(rootViewController: vc!)
                    self.present(navigation, animated: true, completion: nil)
                }else{
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "carSelection") as! CarSelectionViewController
                    vc.userData = self.userData
                    let navigation = UINavigationController(rootViewController: vc)
                    navigation.navigationBar.isTranslucent = false
                    navigation.navigationBar.barTintColor = UIColor(displayP3Red: 40.0/250, green: 39.0/250, blue: 46.0/250, alpha: 1.0)
                    navigation.navigationBar.tintColor = UIColor(displayP3Red: 242.0/250, green: 57.0/250, blue: 45.0/250, alpha: 1.0)
                    navigation.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)]
                    navigation.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(displayP3Red: 243.0/250, green: 245.0/250, blue: 246.0/250, alpha: 1.0)]
                    self.present(navigation, animated: true, completion: nil)
                    
                    
                }
            
                
                
            }else {
                self.userAccount = false
                print("nothing here")
            }
        }
        
    }
   
    
    // LOGIN FUNCTIONS
    //login functions
    func facebookLoginButtonClicked() {
        print("clicked")
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
                    print(user?.email)
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
                    self.getCars(userID: (user?.uid)!)
               
                    self.docUserFinder(userID: (user?.uid)!)
                    
                    
                
                
            }
            
        }
    }
    func getCars(userID: String){
        let userCarCollection = Firestore.firestore().collection("users").document(userID).collection("cars")
        userCarCollection.getDocuments { (snapshot, error) in
            if let error = error{
                print(error)
            }else{
                for document in snapshot!.documents{
                    let newCar = car()
                    let dict = document.data()
                    let model = dict["model"] as? String
                    let year = dict["year"] as? String
                    let make = dict["make"] as? String
                    let color = dict["color"] as? String
                    let tag = dict["tag"] as? String
                    let fuelCapacity = dict["fuelCapacity"] as? Double
                    newCar.color = color
                    newCar.make = make
                    newCar.model = model
                    newCar.tag = tag
                    newCar.year = year
                    newCar.fuelCapacity = fuelCapacity
                    self.userData.carList.append(newCar)
                    
                }
                print(self.userData.carList)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

