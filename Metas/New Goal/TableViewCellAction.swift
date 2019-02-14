//
//  TableViewCellAction.swift
//  Metas
//
//  Created by Alcides Junior on 04/02/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import UIKit

class TableViewCellAction: UITableViewCell {

    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var constraintHeigthCell: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
