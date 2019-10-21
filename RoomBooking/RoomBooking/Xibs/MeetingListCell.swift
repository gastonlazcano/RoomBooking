//
//  MeetingListCell.swift
//  RoomBooking
//
//  Created by Gaston Lazcano on 30/09/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit

class MeetingListCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var answer: UILabel!
    
    var event: EventViewModel?{
        didSet {
            event?.setup()
            title.text = event?.event.title
            room.text = event?.event.location
            time.text = event?.event.startDate
            answer.text = getUserAnswer().rawValue
            status.backgroundColor = event?.statusColor
            setup()
        }
  }

    override func prepareForReuse() {
        title.text = ""
        room.text = ""
        time.text = ""
        status.backgroundColor = .white
    }
    
    //Separator between cells
    override func layoutSubviews() {
       super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0))
        self.backgroundColor = UIColor(red: 0.8863, green: 0.8863, blue: 0.8863, alpha: 1.0)
    }
    
    func setup(){
        title.font = UIFont.boldSystemFont(ofSize: 20.0)
        time.font = UIFont.boldSystemFont(ofSize: 17.0)
    }
    
    private func getUserAnswer() -> MeetingAnswer {
        let userEmail = UserDefaultManager().getUserEmail()
        let organizer = event?.event.organizer
        if (organizer?.email == userEmail){
            return .organizer
        }
        if let attendeeArray = event?.event.attendees{
            for attendee in  attendeeArray {
                if (attendee.email == userEmail) {
                    return attendee.responseStatus.get()
                }
            }
        }
        return .organizer
    }
}
