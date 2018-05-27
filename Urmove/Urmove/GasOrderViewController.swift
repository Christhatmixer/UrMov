//
//  GasOrderViewController.swift
//  Urmove
//
//  Created by Christian on 5/24/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit
import Firebase
import MSCircularSlider
import SJFluidSegmentedControl
class GasOrderViewController: UIViewController, SJFluidSegmentedControlDataSource {
   
    var octaneList = ["87","90","93"]
    var userData = customer()
    var selectedCar = car()
    
   
    @IBOutlet weak var octaneSegmentView: SJFluidSegmentedControl!
    @IBOutlet weak var ninetyThreeView: UIView!
    @IBOutlet weak var ninetyView: UIView!
    @IBOutlet weak var eightySevenView: UIView!
    @IBOutlet weak var fuelSlider: MSCircularSlider!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        fuelSlider.labelFont = .systemFont(ofSize: 25.0)
        octaneSegmentView.dataSource = self
        octaneSegmentView.textFont = .systemFont(ofSize: 25)
   

        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func orderGas(_ sender: Any) {
        let octane = octaneList[octaneSegmentView.currentSegment]
        let gasNeeded = (fuelSlider._maximumValue/100.0 - fuelSlider._minimumValue/100.0) * selectedCar.fuelCapacity!
        let newGasRequest = gasRequest()
        newGasRequest.gasAmount = Double(gasNeeded)
        newGasRequest.car = self.selectedCar
        let vc = storyboard?.instantiateViewController(withIdentifier: "customerHome") as! CustomerHomeViewController
        
        
        
        
    }
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 3
    }
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        return octaneList[index]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
