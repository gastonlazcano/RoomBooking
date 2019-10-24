//
//  DetailViewController.swift
//  RoomBooking
//
//  Created by Agustin Nicolas San Martin Zanetta on 08/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: ViewModel
    
    var eventViewModel: EventViewModel?
    
    // MARK: IBOulets
    
    @IBOutlet weak var attendeesList: UITableView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var roomBookedLabel: UILabel!
    @IBOutlet weak var goingLabel: UILabel!
    @IBOutlet weak var guestsNumber: UILabel!
    @IBOutlet weak var yesQuantity: UILabel!
    @IBOutlet weak var noQuantity: UILabel!
    @IBOutlet weak var maybeQuantity: UILabel!
    @IBOutlet weak var noAnswerQuantity: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var maybeButton: UIButton!
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad () {
        super.viewDidLoad()
        attendeesList.register(UINib(nibName: "DetailAttendeesCell", bundle: nil), forCellReuseIdentifier: "DetailAttendeesCell")
        eventNameLabel.text = eventViewModel?.event.title
        dateTimeLabel.text = eventViewModel?.event.startDate
        roomBookedLabel.text = eventViewModel?.event.location
        guestsNumber.text = "Guests \(eventViewModel?.event.attendees?.count ?? 0)"
        self.refreshAnswerLabels()
        attendeesList.tableFooterView = UIView()
        attendeesList.reloadData()
    }
    
    private func numberOfGuests(meetingAnswer: MeetingAnswer) -> String{
        let numberOfGuests = handleNumberOfGuests(meetingAnswer: meetingAnswer)
        return "\(numberOfGuests)"
    }
    private func handleNumberOfGuests(meetingAnswer: MeetingAnswer) -> Int{
        guard let attendees = eventViewModel?.event.attendees else {return 0}
        var count = 0
        for attendee in attendees {
            let status = attendee.responseStatus.get()
            if meetingAnswer == status {
                count += 1
            }
        }
        return count
    }
    @IBAction func yesButton(_ sender: Any) {
        let oldAnswer = changeAnswer(meetingAnswer: .accepted)
        self.refreshAnswerLabels()
        didChangeButton(button: yesButton, meetingAnswer: oldAnswer)
    }
    @IBAction func noButton(_ sender: Any) {
        let oldAnswer = changeAnswer(meetingAnswer: .declined)
        self.refreshAnswerLabels()
        didChangeButton(button: noButton, meetingAnswer: oldAnswer)
    }
    @IBAction func maybeButton(_ sender: Any) {
        let oldAnswer = changeAnswer(meetingAnswer: .tentative)
        self.refreshAnswerLabels()
        didChangeButton(button: maybeButton, meetingAnswer: oldAnswer)
    }
    
    private func refreshAnswerLabels() {
        yesQuantity.text = "Yes: \(numberOfGuests(meetingAnswer: .accepted))"
        noQuantity.text = "No: \(numberOfGuests(meetingAnswer: .declined))"
        maybeQuantity.text = "Maybe: \(numberOfGuests(meetingAnswer: .tentative))"
        noAnswerQuantity.text = "No answer: \(numberOfGuests(meetingAnswer: .needsAction))"
    }
    private func changeAnswer(meetingAnswer: MeetingAnswer) -> MeetingAnswer{
        guard let attendees = eventViewModel?.event.attendees else {return meetingAnswer}
        var oldAnswer: MeetingAnswer = meetingAnswer
        for var attendee in attendees {
            let emailUD = UserDefaultManager().getUserEmail()
            if emailUD == attendee.email {
                oldAnswer = attendee.responseStatus.get()
                attendee.responseStatus = meetingAnswer
                return oldAnswer
            }
        }
        return oldAnswer
    }
    private func didChangeButton(button: UIButton, meetingAnswer: MeetingAnswer) {
        button.isHighlighted = true
        switch meetingAnswer {
        case .accepted:
            yesButton.isSelected = false
        case .declined:
            noButton.isSelected = false
        case .tentative:
            maybeButton.isSelected = false
        case .needsAction:
            break
        case .organizer:
            break
        }
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
            return eventViewModel?.event.attendees?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*mismo identifier que tiene en el storyboard la celda*/
        let dequeue = tableView.dequeueReusableCell(withIdentifier: "DetailAttendeesCell", for: indexPath)
        guard let cell = dequeue as? DetailAttendeesCell else {
            return UITableViewCell(style: .default, reuseIdentifier: " ")
        }
        if indexPath.section == 0 {
            cell.organizer = eventViewModel?.event.organizer
            print(cell.organizer.email   )
           /* Here should go a logic in which you get who is the organizer from the array of attendees for now i am going to put the same as in the other so the app wont crash*/
           // cell.attendee = eventViewModel?.event.attendees?[indexPath.row]
        } else {
            cell.attendee = eventViewModel?.event.attendees?[indexPath.row]
            print(cell.attendee.email)
         }
        return cell
    }
}
