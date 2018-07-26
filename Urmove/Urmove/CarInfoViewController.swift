//
//  CarInfoViewController.swift
//  Urmove
//
//  Created by Christian on 5/12/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import Firebase
class CarInfoViewController: UIViewController {
    var userData = customer()

    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        guard let color = colorTextField.text else{
            print("no color entered")
            
            return
        }
        guard let model = modelTextField.text else{
            print("No model entered")
            
            return
        }
        guard let make = makeTextField.text else{
            print("Please confirm password")
            
            return
        }
        guard let tag = tagTextField.text else{
            print("Please confirm password")
            
            return
        }
        let carOne = ["color":color,"model":model,"make":make,"tag":tag, "fuelCapacity": 10] as [String: Any]
        let userCarCollection = Firestore.firestore().collection("users").document(userData.userID!).collection("cars")
        userCarCollection.document("car1").setData(carOne)
        let newCar = car()
        newCar.color = color
        newCar.make = make
        newCar.model = model
        newCar.tag = tag
        self.userData.carList.append(newCar)
       
        performSegue(withIdentifier: "phoneVerify", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "phoneVerify"{
            let vc = segue.destination as! PhoneVerificationViewController
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
