//
//  Timetable.swift
//  CalendarView
//
//  Created by kcw3 on 23/5/16.
//  Copyright © 2016 kcw3. All rights reserved.
//

import Foundation

class Timetable {
    
    var lesson_slots_WK: Array<Array<String>>!
    
    init() {
        lesson_slots_WK = Array(count:Constants.NO_SLOTS_PER_DAY, repeatedValue: Array(count:Constants.NO_DAYS_PER_WEEK, repeatedValue: ""))
    }
    
    func insert_lesson (timeslot: Int, day: Int, module_code: String, group_name: String, location: String) {
        // each timeslot no. represent 1 hour, starting from 8am and ending at 6pm, e.g. 8-9 am is 0, 9-10am is 1, ...
        let lesson_info = "\(module_code)\n\(group_name)\n\(location)"
        lesson_slots_WK[timeslot][day] = lesson_info
    }
    
    func get_lesson_info (timeslot: Int, day: Int) -> String {
        return lesson_slots_WK[timeslot][day]
    }
    
    
    
}