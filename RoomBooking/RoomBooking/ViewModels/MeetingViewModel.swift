//
//  MeetingViewModel.swift
//  RoomBooking
//
//  Created by Gaston Lazcano on 27/09/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation
import UIKit

class MeetingViewModel {
    var meeting: Meeting
    var statusColor: UIColor
    
    init(meeting: Meeting){
        
        self.meeting = meeting
        
        switch meeting.answer {
        case .accepted:
            self.statusColor = UIColor(red: 0.7294, green: 0.9294, blue: 0.4549, alpha: 1.0)
        case .declined:
            self.statusColor = .red
        case .pending:
            self.statusColor = .gray
        }
    }
}
