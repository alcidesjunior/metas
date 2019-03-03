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
    
    @IBOutlet weak var viewForLabels: UIView!
    @IBOutlet weak var buttonDone: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    weak var delegate: CellDelegate?
    
    override func layoutSubviews() {
        self.viewForLabels.clipsToBounds = true
        self.viewForLabels.layer.borderWidth = 0
        self.goalImage.layer.cornerRadius = 6
        self.buttonDone.layer.cornerRadius = 6
        self.buttonEdit.layer.cornerRadius = 6
    }
    
    @IBAction func donePressed(_ sender: Any) {
        delegate?.doneTaped(self)
    }
    @IBAction func EditPressed(_ sender: Any) {
        delegate?.editTaped(self)
    }
    
}
