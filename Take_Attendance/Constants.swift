//
//  Constants.swift
//  CalendarView
//
//  Created by kcw3 on 23/5/16.
//  Copyright © 2016 kcw3. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    static let MON: Int = 0
    static let TUES: Int  = 1
    static let WED: Int  = 2
    static let THUR: Int  = 3
    static let FRI: Int  = 4
    
    static let NO_SLOTS_PER_DAY: Int = 10
    static let NO_DAYS_PER_WEEK = 5
    
    static let STARTING_HOUR: Int = 8
    static let DAY_ADJ: Int = 2 //adjust for Sunday as day 1, but we want Monday as day 1 and array starting at 0.
    
    static let TV_BOTTOM_ALLOWANCE: CGFloat = 0.95 //5% allowance of tableview bottom to constraint
    
    static let TIME_SLOTS = ["8-9\nam", "9-10\nam", "10-11\nam", "11-12\nnoon", "12-1\npm", "1-2\npm", "2-3\npm", "3-4\npm", "4-5\npm", "5-6\npm"]
    
}