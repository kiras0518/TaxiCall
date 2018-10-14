//
//  RiderDataCell.swift
//  TaxiCall
//
//  Created by YU on 2018/10/15.
//  Copyright © 2018 ameyo. All rights reserved.
//

import UIKit

class RiderDataCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var dataLable: UILabel!
    
    func configureCell(profileImage: UIImage, email: String, data: String) {
        
        self.profileImage.image = profileImage
        self.userEmail.text = email
        self.dataLable.text = data
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
