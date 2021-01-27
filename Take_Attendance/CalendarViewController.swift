//
//  CalendarViewController.swift
//  CalendarView
//
//  Created by kcw3 on 22/5/16.
//  Copyright © 2016 kcw3. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bar_time_label: UILabel!
    @IBOutlet weak var bar_Mon_label: UILabel!
    @IBOutlet weak var bar_Tue_label: UILabel!
    @IBOutlet weak var bar_Wed_label: UILabel!
    @IBOutlet weak var bar_Thu_label: UILabel!
    @IBOutlet weak var bar_Fri_label: UILabel!
    
    var mytimetable: Timetable!
    let bw :CGFloat = 0.5   //button and label borderwidth
    var cell: TableViewCell!
    var current_hour: Int! // referenced to 8 am as 0, can be -1 for 7 am
    var current_min: Int!
    var current_day: Int!   // referenced to Monday as 0
    
    var cellHeight: CGFloat = 60    //need to initialize with a value for tableView to first load up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        (current_hour, current_min, current_day) = get_currentHourMinDay()
        
        // set the top bar borderwidth
        bar_time_label.layer.borderWidth = bw
        bar_Mon_label.layer.borderWidth = bw
        bar_Tue_label.layer.borderWidth = bw
        bar_Wed_label.layer.borderWidth = bw
        bar_Thu_label.layer.borderWidth = bw
        bar_Fri_label.layer.borderWidth = bw
        
        mytimetable = Timetable()
        
        // manual insert of lessons into timetable for now
        // students should write a function that constructs mttimetable object from server's json data
        // each timeslot no. represent 1 hour, starting from 8am and ending at 6pm, e.g. 8-9 am is 0, 9-10am is 1, ...
        mytimetable.insert_lesson(0, day: Constants.TUES, module_code: "2ENGMEC", group_name: "L1H2", location: "05-02-07")
        mytimetable.insert_lesson(1, day: Constants.TUES, module_code: "2ENGMEC", group_name: "L1H2", location: "05-02-07")
        mytimetable.insert_lesson(0, day: Constants.WED, module_code: "1DIGCM", group_name: "P3P1", location: "07-01-07")
        mytimetable.insert_lesson(1, day: Constants.WED, module_code: "1DIGCM", group_name: "P3P1", location: "07-01-07")
        mytimetable.insert_lesson(5, day: Constants.WED, module_code: "1DIGCM", group_name: "T3P1", location: "08-04-01")
        mytimetable.insert_lesson(6, day: Constants.WED, module_code: "1DIGCM", group_name: "T3P1", location: "08-04-01")
        mytimetable.insert_lesson(5, day: Constants.FRI, module_code: "2ENGMEC", group_name: "T1H2", location: "06-04-07")
        
        mytimetable.insert_lesson(7, day: Constants.FRI, module_code: "MEET", group_name: "ZQJ", location: "07-05-01")
        mytimetable.insert_lesson(2, day: Constants.FRI, module_code: "FREE", group_name: "XXXX", location: "07-05-01")
        mytimetable.insert_lesson(3, day: Constants.FRI, module_code: "LUNCH", group_name: "XXXX", location: "MAKAN")
        mytimetable.insert_lesson(8, day: Constants.FRI, module_code: "FREE", group_name: "XXXX", location: "07-05-01")
        
 
        // setup tableview
        tableView.layoutIfNeeded()
        // calculate the row height to fill the space (minus tab bar)
        cellHeight = (tableView.frame.height-(self.tabBarController?.tabBar.frame.height)!)/CGFloat(Constants.NO_SLOTS_PER_DAY) * Constants.TV_BOTTOM_ALLOWANCE //leave some allowance at the bottom
        cellHeight = floor(cellHeight)
        //print("cell height: \(cellHeight)")
        //print("min: \(current_min)")

        tableView.rowHeight = cellHeight
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .None    //don't want the row separator lines
    }
    
    func get_currentHourMinDay () -> (Int!, Int!, Int!) {
        //get current time and day of week
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute, .Second], fromDate: date)
        let components1 = calendar.components(.Weekday, fromDate: date)
        let hour = components.hour - Constants.STARTING_HOUR
        let min = components.minute
        let day = components1.weekday - Constants.DAY_ADJ
        return (hour, min, day)
    }
    
    func highlight_day() {
        //function to hightlight the current day of the week in the top bar
        (current_hour, current_min, current_day) = get_currentHourMinDay()
        let dayLabel_array = [bar_Mon_label, bar_Tue_label, bar_Wed_label, bar_Thu_label, bar_Fri_label]
        //print("Day: \(Day)")
        for i in 0..<dayLabel_array.count {
            if current_day>=0 && current_day<5 {
                var alpha_value: CGFloat!
                if (i == current_day) {
                    alpha_value = 0.75
                }
                else {
                    alpha_value = 0.5
                }
                dayLabel_array[i].backgroundColor = UIColor.init(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: alpha_value)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear")
        // refresh the calendar's day, time and lesson slots
        refresh_calendar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func refresh_calendar()
        // will also be called in Appdelegate "applicationDidBecomeActive"
        //// refresh the calendar's day, time and lesson slots
    {
        (current_hour,current_min, current_day) = get_currentHourMinDay()
        print("hr: \(current_hour), min: \(current_min)")
        highlight_day()
        tableView.reloadData()
        print("Calendar_refeshed")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.NO_SLOTS_PER_DAY
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        if indexPath.row == current_hour {
            //highlight the current hour timeslot
            cell.timeslot.backgroundColor = UIColor.init(red: 134.0/255.0, green: 140.0/255.0, blue: 255.0/255.0, alpha: 0.9)
        }
        else {
            cell.timeslot.backgroundColor = UIColor.init(red: 134.0/255.0, green: 140.0/255.0, blue: 255.0/255.0, alpha: 0.5)
        }
        //cell.timeslot.frame.size.height = cellHeight  //no need if using auto layout with constraints
        cell.timeslot.layer.borderWidth = bw
        cell.timeslot.text = Constants.TIME_SLOTS[indexPath.row]
        display_lessons(indexPath.row)
        
        return cell
        
    }
    
    func display_lessons(timeslot: Int) {
        //function to populate the calendar with lesson timeslots according to mytimetable object
        
        let buttons = self.cell.get_UIButtons() //get the array of 5 UIbuttons for the current cell
        
        for i in 0..<buttons.count {
            let text = mytimetable.get_lesson_info(timeslot, day: i)    //get the lesson info
            let button = buttons[i]
            button.removeTarget(self, action: #selector(CalendarViewController.take_Attendance(_:)), forControlEvents: .TouchUpInside)  //reset by removing the target functions from all buttons
            
            if text != "" { // if we have a lesson in that timeslot
                button.setTitle(text, forState: UIControlState.Normal)
                button.titleLabel?.textAlignment = NSTextAlignment.Center
                button.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
                button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                button.layer.borderWidth = bw
                var button_color = "white"
                if (i == current_day) {
                    if (timeslot == (current_hour+1) && current_min>54) { //can take attendance 5 mins before lesson
                        button_color = "red"    //highlight the current lesson timeslot
                    }
                    else if (timeslot == current_hour && current_min<55) { // can take attendance within 55 mins from start of lesson
                        button_color = "red"    //highlight the current lesson timeslot
                    }
                }
                
                if (button_color == "red") {    //it's the current lesson timeslot, enable attendance taking function
                    button.tag = timeslot*Constants.NO_DAYS_PER_WEEK + i    // create the tag identifier for running the attenance taking function, corresponds to timeslot and day of week
                    button.addTarget(self, action: #selector(CalendarViewController.take_Attendance(_:)), forControlEvents: .TouchUpInside)
                    button.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.75)
                    button.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
                }
                else {
                    button.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
                    button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                }
            }
        }
    }
    
    
    
    
    @IBAction func take_Attendance(sender: UIButton){
        //function to run when a user activates button to take attendance
        
        //extract timeslot and day of the button from the tag identifier
        let Timeslot:Int = sender.tag/Constants.NO_DAYS_PER_WEEK
        let Day:Int = sender.tag%Constants.NO_DAYS_PER_WEEK
        
        let text = "Do you want to take attendance for \n \(mytimetable.get_lesson_info(Timeslot, day: Day)) ?"
        
        let alertController = UIAlertController(title: "Alert", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        
        //students should add in a handler, i.e. a function to run when user selects OK to take attendance, e.g. scan for iBeacon
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        
        // Move to the UI thread or else may cause lag in UI
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // Show the alert
            self.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

