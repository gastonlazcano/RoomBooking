//
//  GoogleCalendarManager.swift
//  RoomBooking
//
//  Created by Daira Bezzato on 02/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation
import GTMAppAuth
import AppAuth
import GoogleAPIClientForREST

class GoogleCalendarManager {
    
    static let shared = GoogleCalendarManager()
    
    let kIssuer = "https://accounts.google.com"
    let kClientID = "909082270020-frl9af2roa4gq64i2qjt17fh4r93m999.apps.googleusercontent.com"
    let KRedirectURI = "com.googleusercontent.apps.909082270020-frl9af2roa4gq64i2qjt17fh4r93m999:/oauthredirect"
    let kExampleAuthorizerKey = "authorization"
    var authorization: GTMAppAuthFetcherAuthorization?
    let userDefaults = UserDefaults.standard
    let appDelegate = (UIApplication.shared.delegate! as! AppDelegate)
    let fetcherService = GTMSessionFetcherService()
    var oAuthDomainError: OIDErrorCodeOAuthToken?
    
    //Calendar Service Variables
    let calendarService = GTLRCalendarService()
    var events = GTLRCalendar_Events()
    var eventsArray: [Event] = []
    
    var loginDelegate: LoginDelegate!
    
    //Saves the GTMAppAuthFetcher to NcsUserDefaults
    func saveState() {
        if authorization != nil && (authorization?.canAuthorize())! { //Should this be forced?
            guard let encodedData: Data = try? NSKeyedArchiver.archivedData(withRootObject: authorization as Any, requiringSecureCoding: false) else {
                return
            }
            userDefaults.set(encodedData, forKey: kExampleAuthorizerKey)
            userDefaults.synchronize()
        }
        else {
            userDefaults.removeObject(forKey: kExampleAuthorizerKey)
        }
    }
    
    //Loads The GTMAppAuthFetcher From NcsUserDefaults
//    func loadState() {
//        if let _ = userDefaults.object(forKey: kExampleAuthorizerKey)
//        {
//            guard let decoded = userDefaults.object(forKey: kExampleAuthorizerKey) as? Data
//            else {
//                return
//            }
//            guard let testAuth = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded)
//            else {
//                return
//            }
//            authorization = testAuth as? GTMAppAuthFetcherAuthorization
//        }
//    }
    
    func logMessage(_ message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        print(dateString + ": " + message)
    }
    
    // Here we have the auth Logic From our App
    func auth(viewController Presenter: UIViewController) {
        
        let issuer = URL(string: kIssuer)!
        let redirectURI = URL(string: KRedirectURI)!
        
        logMessage("Fetching configuration for issuer: " + issuer.description)
        
        // discovers endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer, completion: {(_ configuration: OIDServiceConfiguration?, _ error: Error?) -> Void in
            
            if configuration == nil {
                self.logMessage("Error retrieving discovery document: " + (error?.localizedDescription)!)
                return
            }
            
            self.logMessage("Got configuration: " + configuration!.description)
            
            // Builds authentication request
            
            let scopes = [OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail, kGTLRAuthScopeCalendarEvents, kGTLRAuthScopeCalendar]
            let request = OIDAuthorizationRequest(configuration: configuration!, clientId: self.kClientID, scopes: scopes, redirectURL: redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
            
            // Performs authentication request
            
            self.logMessage("Initiating authorization request with scope: " + request.scope!.description)
            
            self.appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: Presenter, callback: {(_ authState: OIDAuthState?, _ error: Error?) -> Void in
                
                if authState != nil {
                    self.logMessage("Got authorization tokens. Access token: " + (authState?.lastTokenResponse?.accessToken!.description)!)
                    self.authorization = GTMAppAuthFetcherAuthorization(authState: authState!)
                    self.calendarService.authorizer = self.authorization
                    self.getCalendarInfo(viewController: Presenter) //should this go here?
                    self.saveState()
                    //self.loginDelegate.loginCompleted()
                }
                else {
                    self.logMessage("Authorization error: " + (error?.localizedDescription.description)!)
                }
            })
        })
    }
    
    func handleDownload() -> (Data?, Error?) -> Void {
        return { (data: Data?, error: Error?) -> Void in
            
            if error != nil {
                if error.debugDescription == String(self.oAuthDomainError!.rawValue) {
                    //self.setGtmAuthorization (nil)
                    self.logMessage("Authorization error during token refresh, clearing state." + "\(String(describing: error))")
                } else {
                    self.logMessage("Transient error during token refresh." + "\(String(describing: error))")
                }
                return
            }
            
            let jsonError: Error? = nil
            let jsonDictionaryArray = try? JSONSerialization.jsonObject(with: data!, options: []) //I Should not force this
            
            if jsonError != nil {
                self.logMessage("JSON decoding error" + "\(String(describing: error))")
                return
            }
            
            //Success Response
            self.logMessage("Success:" + "\(String(describing: jsonDictionaryArray))")
            
            //Here the data is being saved in user defaults
            if let response = jsonDictionaryArray as? [String:AnyObject] {
                let fullName = response["name"] as! String
                let email = response["email"] as! String
                let profileImage = response["picture"] as! String
                UserDefaultManager().setUser(fullname: fullName, email: email, profileimage: profileImage)
            }
        }
    }
    
    func getCalendarInfo(viewController: UIViewController) {
        self.logMessage(" Performing Calendar Info Request")
        //calendarService.shouldFetchNextPages = true
        calendarService.isRetryEnabled = true
        
        let calendarID = "primary"
        
        let eventsQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarID)
        //eventsQuery.maxResults = 20
        eventsQuery.singleEvents = true
        eventsQuery.orderBy = kGTLRCalendarOrderByStartTime
        
        calendarService.executeQuery(eventsQuery, delegate: viewController, didFinish: #selector(viewController.displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
}

extension UIViewController {
    
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRCalendar_Events,
        error : Error?)  {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        var eventString = ""
        
        if let events = response.items, !events.isEmpty {
            for event in events {
                let start : GTLRDateTime = event.start?.dateTime ?? event.start!.date!
                let end : GTLRDateTime = event.end?.dateTime ?? event.end!.date!
                
                var attendeesData: [Attendee] = []
                
                event.attendees?.forEach({ (attendee) in
                    
                    let isOrganizer = attendee.organizer as? Bool ?? false
                    let email = attendee.email ?? ""
                    let name = attendee.displayName ?? ""
                    let responseStatus = attendee.responseStatus
                    
                    let attendeeInfo = Attendee(isOrganizer: isOrganizer, email: email, displayName: name, responseStatus: MeetingAnswer(rawValue: responseStatus!)!)
                    attendeesData.append(attendeeInfo)
                })
                
                let title = event.summary ?? "No traje titulo"
                let description = event.description
                let location = event.location ?? "No traje location"
                let organizerMail = event.organizer?.email ?? ""
                let organizerDisplayName = event.organizer?.displayName ?? ""
                
                let organizer = Organizer(email: organizerMail, displayName: organizerDisplayName)
                let startDate = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short
                )
                let endDate = DateFormatter.localizedString(
                    from: end.date,
                    dateStyle: .short,
                    timeStyle: .short
                )
                
                let eventData = Event(title: title, description: description, location: location, startdate: startDate, enddate: endDate, attendees: attendeesData, organizer: organizer)
                
                GoogleCalendarManager.shared.logMessage("Hola ESTA ES LA DATA DE LOS EVENTOS JEJEJEJEJEJE : \(eventData)")
                GoogleCalendarManager.shared.eventsArray.append(eventData)
            }
        } else {
            eventString = "No upcoming events found."
        }
        GoogleCalendarManager.shared.logMessage("This is what i got" + eventString)
        GoogleCalendarManager.shared.loginDelegate.loginCompleted()
    }
}
