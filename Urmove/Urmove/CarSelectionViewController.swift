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
class CarSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var userData = customer()
    let cellPercentWidth: CGFloat = 0.9
    var newGasRequest = gasRequest()
    @IBOutlet weak var pageControl: UIPageControl!
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    @IBOutlet weak var carCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        centeredCollectionViewFlowLayout = carCollectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        carCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        carCollectionView.delegate = self
        carCollectionView.dataSource = self
        centeredCollectionViewFlowLayout.itemSize = CGSize(width: view.bounds.width * cellPercentWidth, height: view.bounds.height * cellPercentWidth * cellPercentWidth)
        carCollectionView.showsVerticalScrollIndicator = false
        carCollectionView.showsHorizontalScrollIndicator = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData.carList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let storage = Storage.storage().reference().child(userData.userID!).child("cars").child("car" + String(indexPath.row))
        let cell = carCollectionView.dequeueReusableCell(withReuseIdentifier: "car", for: indexPath) as! CarCollectionViewCell
        let cellCar = userData.carList[indexPath.row]
        print(cellCar)
        cell.carFuelCapacityLabel.text = String(describing: Int(cellCar.fuelCapacity!))
        cell.carNameLabel.text = cellCar.model!
        cell.carImageView.sd_setImage(with: storage, placeholderImage: #imageLiteral(resourceName: "car"))
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let path = carCollectionView.indexPathsForSelectedItems
        //let currentCell = tableView.cellForRow(at: indexPath)! as! EventTableViewCell
        let chosenCar = self.userData.carList[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "fuelOrder") as! GasOrderViewController
        vc.userData = self.userData
        vc.selectedCar = chosenCar
        print(chosenCar.model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.row
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
