//
//  CustomWeatherTableViewCell.swift
//  CodingChallenge
//
//  Created by Ayus Salleh on 06/01/2017.
//  Copyright © 2017 SubZ3r0X. All rights reserved.
//

import UIKit

class CustomWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var weatherDateTime: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var weatherTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
