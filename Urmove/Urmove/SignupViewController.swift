//
//  SignupViewController.swift
//  Urmove
//
//  Created by Christian on 5/10/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import Firebase
import Alertift
class SignupViewController: UIViewController {
    var userData = customer()
    var userAccount: Bool?
    var userRef: DocumentReference!
    var userCollection: CollectionReference!
    var userFormsCollection: CollectionReference!
    var userForm: DocumentReference!

    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerFunc(_ sender: Any) {
        guard let email = emailTextField.text else{
            print("no email entered")
            
            return
        }
        guard let password = passwordTextField.text else{
            print("No password entered")
            
            return
        }
        guard let confirmedPassword = passwordConfirmTextField.text else{
            print("Please confirm password")
            
            return
        }
        if password != confirmedPassword{
            print("Passwords do not match")
            
            
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                Alertift.alert(title: "Error", message: error.localizedDescription).action(.default("OK")).show(on: self)
                print(error)
                
            }else{
                self.docUserFinder(userID: (user?.uid)!, email: email)
            }
        }
    }
    func docUserFinder(userID: String, email: String){
        let db = Firestore.firestore()
        userRef = db.collection("users").document(userID)
        userRef.getDocument { (document, error) in
            if (document?.exists)! {
                self.userAccount = true
                Alertift.alert(title: "User Exist", message: "This email is already in use.").action(.default("OK"))
                
                
                
            }else {
                self.userAccount = false
                let newUser: [String: Any] = [
                    "email": email,
                    "userID": userID,
                    "firstName": self.firstNameTextField.text!,
                    "lastName": self.lastNameTextField.text!,
                    "authenticated": false
                    
                    
                ]
                let updatedUser = customer()
                self.userData.firstName = newUser["firstName"] as? String
                self.userData.lastName = newUser["lastName"] as? String
                self.userData.userID = newUser["userID"] as? String
                self.userData.email = newUser["email"] as? String
                self.userData.authenticated = newUser["authenticated"] as? Bool
    
                
                db.collection("users").document(userID).setData(newUser)
                print("nothing here")
                
                self.performSegue(withIdentifier: "carInfo", sender: self
                )
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "carInfo"{
            let vc = segue.destination as! CarInfoViewController
            vc.userData = self.userData
            
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
