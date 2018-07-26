//
//  PastFillTableViewCell.swift
//  Urmove
//
//  Created by Christian on 7/22/18.
//  Copyright © 2018 ADNAP. All rights reserved.
//

import UIKit

class PastFillTableViewCell: UITableViewCell {
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var vehicleNameLabel: UILabel!
    
    
    @IBOutlet weak var fillPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
