//
//  PhoneVerificationViewController.swift
//  Urmove
//
//  Created by Christian on 5/19/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import Alamofire
class PhoneVerificationViewController: UIViewController {
    let backendBaseURL: String? = "https://urmove.herokuapp.com/"

    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getCodeFunc(_ sender: Any) {
        sendNumber(phoneNumber: self.phoneNumberTextField.text!)
    }
    func sendNumber(phoneNumber: String){
        let urlString = "https://urmove.herokuapp.com/requestVerificationCode"
        var params = ["phoneNumber": phoneNumber] as [String : Any]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            print(response.response)
            
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
