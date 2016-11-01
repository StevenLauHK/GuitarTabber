//
//  TableViewCell.swift
//  Guitar Tabber
//
//  Created by Lau Kin Wai on 10/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var playImage: UIImageView!
    
    @IBOutlet var songName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
