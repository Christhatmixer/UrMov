//
//  codeVerificationViewController.swift
//  Urmove
//
//  Created by Christian on 5/20/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import NVActivityIndicatorView
import CBPinEntryView
class codeVerificationViewController: UIViewController {
    var userData = customer()

    @IBOutlet weak var pinEntryView: CBPinEntryView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkCodeFunction(_ sender: Any) {
        
        verifyCode(pin: pinEntryView.getPinAsString())
    }
    func verifyCode(pin: String){
        let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor(displayP3Red: 33.0/255, green: 141.0/255, blue: 22/255, alpha: 1.0), padding: 0)
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating() //UI will freeze alamofire. Give user something to look at
        self.view.addSubview(loadingIndicator)
        let urlString = "https://urmove.herokuapp.com/checkVerificationCode"
        var params = ["pin": pin] as [String : Any]
        Alamofire.request("https://urmove.herokuapp.com/checkVerificationCode", method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
            print(response.response)
            print(response.result.description)
            if response.result.description == "SUCCESS"{
                let userDocument = Firestore.firestore().collection("users").document(self.userData.userID!)
                userDocument.updateData(["authenticated": true], completion: { (error) in
                    if let error = error{
                        print(error)
                    }else{
                        print("success")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "carSelection") as! CarSelectionViewController
                        vc.userData = self.userData
                        let navigation = UINavigationController(rootViewController: vc)
                        
                        
                        self.present(navigation, animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "customerHome", sender: self)
                    }
                })
            }
            
            loadingIndicator.stopAnimating()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customerHome"{
            let vc = segue.destination as? CustomerHomeViewController
            
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
