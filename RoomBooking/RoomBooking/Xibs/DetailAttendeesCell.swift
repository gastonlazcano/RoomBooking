//
//  DetailAttendeesCell.swift
//  RoomBooking
//
//  Created by Agustin Nicolas San Martin Zanetta on 03/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit

class DetailAttendeesCell: UITableViewCell {
    
    @IBOutlet weak var attendeeName: UILabel!
    @IBOutlet weak var isOrganizer: UILabel!
    
    var attendee: Attendee! {
          didSet {
            if attendee.displayName != nil {
                attendeeName.text = attendee.displayName
                isOrganizer.isHidden = true
            } else {
                attendeeName.text = attendee.email
                isOrganizer.isHidden = true
            }
       }
    }
    var organizer: Organizer! {
          didSet {
            if organizer.displayName != nil {
                attendeeName.text = organizer.displayName
                isOrganizer.text = "Is organizer"
            } else {
                attendeeName.text = organizer.email
                isOrganizer.text = "Is organizer"
            }
       }
    }
    
    override func prepareForReuse() {
        attendeeName.text = ""
        isOrganizer.text = ""
    }
}
