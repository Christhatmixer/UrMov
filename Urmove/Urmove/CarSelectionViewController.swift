//
//  CarSelectionViewController.swift
//  Urmove
//
//  Created by Christian on 5/28/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import CenteredCollectionView
import FirebaseStorageUI
import Firebase
class CarSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var userData = customer()
    var carList = [car]()
    let cellPercentWidth: CGFloat = 0.9
    var newGasRequest = gasRequest()
    @IBOutlet weak var pageControl: UIPageControl!
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    @IBOutlet weak var carCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = userData.carList.count
        
        centeredCollectionViewFlowLayout = carCollectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        carCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        carCollectionView.delegate = self
        carCollectionView.dataSource = self
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: view.bounds.width * cellPercentWidth, height: view.bounds.height * cellPercentWidth * cellPercentWidth)
        carCollectionView.showsVerticalScrollIndicator = false
        carCollectionView.showsHorizontalScrollIndicator = false
        getCars(userID: userData.userID!)
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.carList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let storage = Storage.storage().reference().child(userData.userID!).child("cars").child("car" + String(indexPath.row))
        let cell = carCollectionView.dequeueReusableCell(withReuseIdentifier: "car", for: indexPath) as! CarCollectionViewCell
        let cellCar = self.carList[indexPath.row]
        print(cellCar)
        cell.carFuelCapacityLabel.text = String(describing: Int(cellCar.fuelCapacity ?? 10))
        cell.carNameLabel.text = cellCar.model!
        cell.carImageView.sd_setImage(with: storage, placeholderImage: #imageLiteral(resourceName: "car"))
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let path = carCollectionView.indexPathsForSelectedItems
        //let currentCell = tableView.cellForRow(at: indexPath)! as! EventTableViewCell
        let chosenCar = carList[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "fuelOrder") as! GasOrderViewController
        vc.userData = self.userData
        vc.selectedCar = chosenCar
        print(chosenCar.model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
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
                    self.carList.append(newCar)
                    
                }
                self.carCollectionView.reloadData()
                print(self.carList)
                
            }
        }
    }
    
    @IBAction func showMenuFunc(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "menu") as! MenuTableViewController
        vc.userData = self.userData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigationfu
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
