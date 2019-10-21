//
//  HomeViewController.swift
//  RoomBooking
//
//  Created by Daira Bezzato on 26/09/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Atributes
    var eventsArray: [Event] = []

    var todayMeetings: [EventViewModel] = []
    var todayMeetSearching: [EventViewModel] = []
    var tomorrowMeetings: [EventViewModel] = []
    var tomorrowMeetSearching: [EventViewModel] = []
    var isSearching = false
    
    //Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var meetingsList: UITableView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsArray = GoogleCalendarManager.shared.eventsArray
        searchBar.isHidden = true
        let searchImage  = UIImage(systemName: "magnifyingglass")
        let searchButton = UIBarButtonItem(image: searchImage,  style: .plain, target: self, action: #selector(didTapSearchButton))
        navBarItem.rightBarButtonItems = [searchButton]
        meetingsList.backgroundColor = UIColor(red: 0.8863, green: 0.8863, blue: 0.8863, alpha: 1.0)
        meetingsList.register(UINib.init(nibName: "MeetingListCell", bundle: nil), forCellReuseIdentifier: "MeetingListCell")
        retriveData()
        meetingsList.reloadData()
        meetingsList.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func retriveData() {
        filterEvents()
        //MAKE A COPY OF THE ORIGINAL ARRAYS
        todayMeetSearching = todayMeetings
        tomorrowMeetSearching = tomorrowMeetings
    }
    
  
    @objc func didTapSearchButton(sender: AnyObject){
        searchBar.isHidden = false
        print("SEARCH BUTTON CLICKED")
    }
    
    func filterEvents() {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let currentDate = dateFormatter.string(from: Date())
        print("HOY ES: " + currentDate)
        for event in eventsArray {
            let eventDate = event.startDate.split(separator: ",") // that gives me in the 0 position of the array an string with this format "MM/dd/yy"
            print("EL EVENTO ES: " + eventDate[0])
            if(eventDate[0] == currentDate) {
                let eventVm = EventViewModel(event: event)
                todayMeetings.append(eventVm)
            }
        }
    }
    
    func getTomorrow() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .day); // +1 day
        
        let now = Date() // Current date
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: now)  // Add the DateComponents
        
        return tomorrow!
    }
   /* func getMonthDays(month: Int) -> Int {
        var days: Int
        switch month {
        case 4,6,9,11:
            days = 30;
        case 1,3,5,7,8,10,12:
            days = 31;
        case 2:
            days = 28;
        default:
            days = 0
        }
        return days
    }
 */
}

//TABLE VIEW

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.isHidden = true
        view.endEditing(true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        label.backgroundColor = UIColor(red: 0.8863, green: 0.8863, blue: 0.8863, alpha: 1.0)
        if(section == 0){
            label.text = "Today"
        }
        else{
            label.text = "Tomorrow"
        }
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            if(isSearching){
                return todayMeetSearching.count
            }else{
                return todayMeetings.count
            }
        } else {
            //section 1
            if(isSearching){
                return tomorrowMeetSearching.count
            }else{
                return tomorrowMeetings.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event: EventViewModel
        /*mismo identifier que tiene en el storyboard la celda*/
        let dequeue = tableView.dequeueReusableCell(withIdentifier: "MeetingListCell", for: indexPath)
        guard let cell = dequeue as? MeetingListCell else {
            return UITableViewCell(style: .default, reuseIdentifier: " ")
        }
        if(isSearching) {
             event = indexPath.section == 0 ? todayMeetSearching[indexPath.row] : tomorrowMeetSearching[indexPath.row]
        } else {
             event = indexPath.section == 0 ? todayMeetings[indexPath.row] : tomorrowMeetings[indexPath.row]
        }
        
        cell.event = event
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         self.performSegue(withIdentifier: "DetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        guard let destination = segue.destination as? DetailViewController else {
            return
        }
        guard let index = meetingsList.indexPathForSelectedRow?.row else {
            return
        }
        
        if(meetingsList.indexPathForSelectedRow?.section == 0) {
            switch isSearching {
            case true:
                destination.eventViewModel = todayMeetSearching[index]
                print(todayMeetSearching[index].event.title)
            case false:
                destination.eventViewModel = todayMeetings[index]
                print(todayMeetSearching[index].event.title)
            }
        }
        else{
            switch isSearching {
            case true:
                destination.eventViewModel = tomorrowMeetSearching[index]
                print(tomorrowMeetSearching[index].event.title)
            case false:
                destination.eventViewModel = tomorrowMeetings[index]
                print(tomorrowMeetings[index].event.title)
            }
        }
    }
}
 
//SEARCHBAR

extension HomeViewController: UISearchBarDelegate {
    
   /* func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let eventSearch = searchBar.text else {return}
        if (eventSearch != ""){
            filterMeetings(eventTitle: eventSearch )
        }
        meetingsList.reloadData()
    }
    */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        if(searchText != ""){
            filterMeetings(eventTitle: searchText)
        }
        else{
            meetingsList.isHidden = false
            isSearching = false
            todayMeetSearching = todayMeetings
            tomorrowMeetSearching = tomorrowMeetings
        }
        meetingsList.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        isSearching = false
        todayMeetSearching = todayMeetings
        tomorrowMeetSearching = tomorrowMeetings
        meetingsList.reloadData()
    }
    
    private func filterMeetings(eventTitle: String) {
        todayMeetSearching = todayMeetings
        tomorrowMeetSearching = tomorrowMeetings
        todayMeetSearching = todayMeetSearching.filter { $0.event.title.contains(eventTitle) }
        tomorrowMeetSearching = tomorrowMeetSearching.filter { $0.event.title.contains(eventTitle) }
       
        if(todayMeetSearching.count == 0 && tomorrowMeetSearching.count == 0){
            meetingsList.isHidden = true
        }
        else{
             meetingsList.isHidden = false
        }
    }
}


