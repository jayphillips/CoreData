//
//  TaskCell.swift
//  CoreDataToDoApp
//
//  Created by Jay Phillips on 1/1/19.
//  Copyright © 2019 Jay Phillips. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
