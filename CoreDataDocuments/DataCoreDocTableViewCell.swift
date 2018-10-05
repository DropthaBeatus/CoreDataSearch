//
//  DataCoreDocTableViewCell.swift
//  CoreDataDocuments
//
//  Created by Liam Flaherty on 9/21/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//

import UIKit

class DataCoreDocTableViewCell: UITableViewCell {

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var SizeLabel: UILabel!
    @IBOutlet weak var DocumentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
