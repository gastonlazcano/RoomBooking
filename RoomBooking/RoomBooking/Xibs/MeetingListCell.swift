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
    @IBOutlet weak var answer: UIButton!
    @IBOutlet weak var status: UIView!
    
    var event: EventViewModel?{
        didSet {
            event?.setup()
            title.text = event?.event.title
            room.text = event?.event.location
            time.text = event?.event.startDate
            answer.backgroundColor = event?.statusColor
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
}
