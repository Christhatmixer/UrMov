//
//  PastFillsViewController.swift
//  Urmove
//
//  Created by Christian on 7/20/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import Firebase
class PastFillsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var pastFills = [gasRequest]()
    var userData = customer()
    @IBOutlet weak var pastFillsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pastFillsTableView.delegate = self
        pastFillsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        firebaseGetPastFills(userID: userData.userID!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TABLE VIEW STUFF
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastFills.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pastFillsTableView.dequeueReusableCell(withIdentifier: "pastFill", for: indexPath) as! PastFillTableViewCell
        let pastFill = pastFills[indexPath.row]
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        cell.fillPriceLabel.text = numberFormatter.string(from: pastFill.price! as NSNumber)
        cell.vehicleNameLabel.text = pastFill.car!.make! + " " + pastFill.car!.model!
        
        return cell
    }
    
    func firebaseGetPastFills(userID: String){
        let db = Firestore.firestore()
        let pastFillCollection = db.collection("requests").whereField("userID", isEqualTo: userData.userID!)
        pastFillCollection.getDocuments { (snapshot, error) in
            if let error = error{
                print(error)
            }else{
                for document in (snapshot?.documents)!{
                    let dict = document.data()
                
                    let oldGasRequest = gasRequest()
                    let oldCar = car()
                    let price = dict["price"] as! Double
                    let userID = dict["userID"] as! String
                    let vehicle = dict["car"] as! [String:Any]
                    let make = vehicle["make"] as! String
                    let model = vehicle["model"] as! String
                    oldCar.make = make
                    oldCar.model = model
                    oldGasRequest.price = price
                    oldGasRequest.userID = userID
                    oldGasRequest.car = oldCar
                   
                    self.pastFills.append(oldGasRequest)
                    
                }
                self.pastFillsTableView.reloadData()
            }
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
