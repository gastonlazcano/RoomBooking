//
//  EventViewModel.swift
//  RoomBooking
//
//  Created by Agustin Nicolas San Martin Zanetta on 07/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation
import UIKit

class EventViewModel {
    
    var event: Event
    var statusColor: UIColor?
    
    init(event:Event){
        self.event = event
        setup()
    }

    func setup(){
        let attendee = getAttendee()
        guard let user = attendee else { return }
       
        switch user.responseStatus{
        case .accepted:
            self.statusColor = UIColor(red: 0.7294, green: 0.9294, blue: 0.4549, alpha: 1.0)
        case .needsAction:
            self.statusColor = .gray
        case .declined:
            self.statusColor = .red
        case .tentative:
            self.statusColor = .blue
        case .organizer:
            self.statusColor = .orange
        }
    }
    
    private func getAttendee() -> Attendee? {
        let user = UserDefaultManager()
        guard let attendees = event.attendees else { return nil }
       
        if(user.getUserEmail() == event.organizer.email){
            return Attendee(isOrganizer: true, email: user.getUserEmail(), displayName: user.getUserName(), responseStatus: .organizer)
        }
        for attendee in (attendees) {
            if (attendee.email == user.getUserEmail()) {
                return attendee
            }
        }
        
        return nil
    }
}
