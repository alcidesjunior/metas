//
//  CellDelegate.swift
//  Metas
//
//  Created by Alcides Junior on 23/02/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import Foundation
protocol CellDelegate: class{
    func editTaped(_ cell: GoalCollectionViewCell)
    func doneTaped(_ cell: GoalCollectionViewCell)
}
