//
//  TableViewCell.swift
//  CalendarView
//
//  Created by kcw3 on 22/5/16.
//  Copyright © 2016 kcw3. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeslot: UILabel!
    
    @IBOutlet weak var Mon_button_title: UIButton!
    
    @IBOutlet weak var Tue_button_title: UIButton!
    
    @IBOutlet weak var Wed_button_title: UIButton!
    
    @IBOutlet weak var Thu_button_title: UIButton!
    
    @IBOutlet weak var Fri_button_title: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeslot.layer.borderWidth = 0.5
    }
    
    func get_UIButtons() -> [UIButton] {
        return [Mon_button_title, Tue_button_title, Wed_button_title, Thu_button_title, Fri_button_title]
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
