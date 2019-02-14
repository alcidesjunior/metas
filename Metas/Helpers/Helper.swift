//
//  Helper.swift
//  Metas
//
//  Created by Alcides Junior on 12/02/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import Foundation
class Helper: NSObject{
    
    static func dateToString(date: Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let str = formatter.string(from: date)
        let currentDate = formatter.date(from: str)
        return formatter.string(from: currentDate!)
    }
    static func stringToDate(dateString: String)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dt = formatter.date(from: dateString)
        let currentString = formatter.string(from: dt!)
        return formatter.date(from: currentString)!
    }
}
