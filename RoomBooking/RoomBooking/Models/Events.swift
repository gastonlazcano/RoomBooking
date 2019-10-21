//
//  Events.swift
//  RoomBooking
//
//  Created by Daira Bezzato on 03/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation

struct CalendarResponse: Codable {
    var items: [Event]
}

struct Event: Codable {
    var title: String
    var description: String
    var location: String // Sometime here we have a zoom link, we should manage this
    var startDate: String//StartDate // start (retrieves a string so we need to think how to make it a date)
    var endDate: String//EndDate //  (it happens the same that with start date)
    var attendees: [Attendee]?
    var organizer: Organizer
    
    init (title: String, description: String, location: String, startdate: String, enddate: String, attendees: [Attendee], organizer: Organizer) {
        self.title = title
        self.description = description
        self.location = location
        self.startDate = startdate
        self.endDate = enddate
        self.organizer = organizer
        
        var auxAttendeesArray:[Attendee] = []
        
        attendees.forEach { (attendee) in
            if attendee.isOrganizer == false {
                auxAttendeesArray.append(attendee)
            }
        }
        self.attendees = auxAttendeesArray
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "summary"
        case description
        case location
        case startDate = "start"
        case endDate = "end"
        case attendees
        case organizer
    }
}
struct Organizer: Codable {
    var email: String
    var displayName: String?
}

struct Attendee: Codable {
    var isOrganizer: Bool
    var email: String
    var displayName: String?
    var responseStatus: MeetingAnswer
}

enum  MeetingAnswer: String, Codable {
    case accepted
    case needsAction
    case declined
    case tentative
    case organizer
    
    func get() -> MeetingAnswer {
        switch self {
        case .accepted:
            return self
        case .needsAction:
            return self
        case .declined:
            return self
        case .tentative:
            return self
        case .organizer:
            return self
        }
    }
}

