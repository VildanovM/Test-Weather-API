//
//  TableViewCell.swift
//  Test Weather API
//
//  Created by Максим Вильданов on 16.07.2018.
//  Copyright © 2018 Максим Вильданов. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var currentTimeOutlet: UILabel!
    
    @IBOutlet weak var cityNameOutlet: UILabel!
    
    @IBOutlet weak var degriesInCelsOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
