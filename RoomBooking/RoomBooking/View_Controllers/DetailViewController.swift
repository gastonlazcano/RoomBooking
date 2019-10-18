//
//  DetailViewController.swift
//  RoomBooking
//
//  Created by Agustin Nicolas San Martin Zanetta on 03/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: ViewModel & Properties
    
    var eventViewModel: EventViewModel!  {
        didSet {
            eventNameLabel.text = eventViewModel.event.title
            dateTimeLabel.text = eventViewModel.event.startDate.dateTime
            roomBookedLabel.text = eventViewModel.event.location

            var attendeesArray = eventViewModel.event.attendees
        }
    }
    
    // MARK: IBOulets
    
    @IBOutlet weak var attendeesList: UITableView!
        
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
        
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var roomBookedLabel: UILabel!
    @IBOutlet weak var goingLabel: UILabel!
    
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
    }
}

// MARK: TableView

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        } else {
            return eventViewModel.event.attendees?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*mismo identifier que tiene en el storyboard la celda*/
        
        let dequeue = tableView.dequeueReusableCell(withIdentifier: "DetailAttendeesCell", for: indexPath)
        
        guard let cell = dequeue as? DetailAttendeesCell else {
            return UITableViewCell(style: .default, reuseIdentifier: " ")
        }
        guard let attendeesArray = eventViewModel.event.attendees else {return UITableViewCell()}
        
        let organizer = handleTableViewSearchingForOrganizer()
        
        let attendee = indexPath.section == 0 ? organizer[indexPath.row] : attendeesArray[indexPath.row]
        
        cell.attendee = attendee
        
        return cell
    }
    
    private func handleTableViewSearchingForOrganizer() -> [Attendees]{
        
        var organizer: [Attendees] = []
        
        if var array = self.eventViewModel.event.attendees {
            for (index, attendee) in array.enumerated() {
                if attendee.isOrganizer == true {
                    organizer.append(attendee)
                    array.remove(at: index)
                }
            }
        }
        return organizer
    }
}


