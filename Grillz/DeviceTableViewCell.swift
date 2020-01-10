//
//  DeviceTableViewCell.swift
//  Grillz
//
//  Created by Steve Mitchell on 1/10/20.
//  Copyright © 2020 Steve Mitchell. All rights reserved.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceNameLable: UILabel!
    @IBOutlet weak var deviceDescriptionLable: UILabel!
    @IBOutlet weak var deviceDistanceLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
