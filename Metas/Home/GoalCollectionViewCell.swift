//
//  GoalCollectionViewCell.swift
//  Metas
//
//  Created by Alcides Junior on 09/02/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import UIKit

class GoalCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var goalImage: UIImageView!
    
    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var actionsQuantityLabel: UILabel!
    @IBOutlet weak var goalDate: UILabel!
    
    @IBOutlet weak var editGoalButton: UIButton!
}
