//
//  PhoneVerificationViewController.swift
//  Urmove
//
//  Created by Christian on 5/19/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
class PhoneVerificationViewController: UIViewController {
    let backendBaseURL: String? = "https://urmove.herokuapp.com/"
    var userData = customer()
    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.textColor = UIColor.white
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getCodeFunc(_ sender: Any) {
        self.userData.phoneNumber = self.phoneNumberTextField.text
        sendNumber(phoneNumber: self.phoneNumberTextField.text!)
      
    }
    func sendNumber(phoneNumber: String){
        let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(displayP3Red: 33.0/255, green: 141.0/255, blue: 22/255, alpha: 1.0), padding: 0)
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating() //UI will freeze alamofire. Give user something to look at
        self.view.addSubview(loadingIndicator)
        let urlString = "https://urmove.herokuapp.com/requestVerificationCode"
        var params = ["phoneNumber": phoneNumber] as [String : Any]
        Alamofire.request("https://urmove.herokuapp.com/requestVerificationCode", method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            print(response.response)
            print(response.result.description)
            if response.result.description == "SUCCESS"{
                loadingIndicator.stopAnimating()
                self.performSegue(withIdentifier: "codeVerification", sender: self)
            }
            
        }
     
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codeVerification"{
            let vc = segue.destination as! codeVerificationViewController
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
