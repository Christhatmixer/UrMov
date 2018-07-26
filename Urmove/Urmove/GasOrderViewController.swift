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
class GasOrderViewController: UIViewController, SJFluidSegmentedControlDataSource, MSDoubleHandleCircularSliderDelegate {
    
    
   
    var octaneList = ["87","90","93"]
    var userData = customer()
    var selectedCar = car()
    var gasPrice = 2.88
    var gasNeeded: Double?
    var newGasRequest = gasRequest()
    var price: Double?
   
    @IBOutlet weak var octaneSegmentView: SJFluidSegmentedControl!
    @IBOutlet weak var ninetyThreeView: UIView!
    @IBOutlet weak var ninetyView: UIView!
    @IBOutlet weak var eightySevenView: UIView!
    @IBOutlet weak var fuelSlider: MSCircularSlider!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fuelSlider.delegate = self
        fuelSlider.labelFont = .systemFont(ofSize: 25.0)
        octaneSegmentView.dataSource = self
        octaneSegmentView.textFont = .systemFont(ofSize: 25)
   

        // Do any additional setup after loading the view.
    }
   
    
    @IBAction func orderGas(_ sender: Any) {
        let octane = octaneList[octaneSegmentView.currentSegment]
        let gasNeeded = (fuelSlider._maximumValue/100.0 - fuelSlider._minimumValue/100.0) * selectedCar.fuelCapacity! ?? 10
        
      
        self.newGasRequest.gasAmount = Double(gasNeeded)
        self.newGasRequest.car = self.selectedCar
        self.newGasRequest.octane = octaneList[octaneSegmentView.currentSegment]
        self.newGasRequest.price = self.price!
        print(self.price)
        self.newGasRequest.textPrice = self.priceLabel.text
        let vc = storyboard?.instantiateViewController(withIdentifier: "customerHome") as! CustomerHomeViewController
        vc.newGasRequest = self.newGasRequest
        vc.selectedCar = self.selectedCar
        vc.userData = self.userData
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 3
    }
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        return octaneList[index]
    }
    func circularSlider(_ slider: MSCircularSlider, endedTrackingWith firstValue: Double, secondValue: Double, isFirstHandle: Bool) {
        
        print(firstValue)
    }
    func circularSlider(_ slider: MSCircularSlider, startedTrackingWith firstValue: Double, secondValue: Double, isFirstHandle: Bool) {
        print(firstValue)
        /*
        let gasNeeded = (secondValue/100.0 - firstValue/100.0) * 8
        var price = gasNeeded * 2.88
        priceLabel.text = String(price)
 */
    }
    func circularSlider(_ slider: MSCircularSlider, valueChangedTo firstValue: Double, secondValue: Double, isFirstHandle: Bool?, fromUser: Bool) {
        
    
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let gasNeeded = (secondValue/100.0 - firstValue/100.0) * 8
        self.price = gasNeeded * 2.88
        print(self.price)
        priceLabel.text = numberFormatter.string(from: price! as NSNumber)
    }
    

    @IBAction func fuelSliderValueChanged(_ sender: Any) {
        print("touched")
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
