//
//  GoalStruct.swift
//  Metas
//
//  Created by Alcides Junior on 08/02/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import Foundation
import UIKit

struct GoalStruct{
    var goalId: String
    var goalImage: UIImage
    var goalTitle: String
    var goalDate: String
    var goalActions: [Action]
    var status: Bool
    
    init(goalId: String, goalImage: UIImage, goalTitle: String, goalDate: String, goalActions:[Action], status: Bool){
        self.goalId = goalId
        self.goalImage = goalImage
        self.goalTitle = goalTitle
        self.goalDate = goalDate
        self.goalActions = goalActions
        self.status = status
    }
}
