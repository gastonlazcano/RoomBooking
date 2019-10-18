//
//  UserDefaultManager.swift
//  RoomBooking
//
//  Created by Gaston Lazcano on 01/10/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation

class UserDefaultManager {
    
    let defaults = UserDefaults.standard
    
    func getUserEmail() -> String{
        guard let userVm = getUser() else {
            return ""
        }
        return userVm.user.email
    }
    
    func getUserName() -> String{
        guard let userVm = getUser() else {
            return ""
        }
        return userVm.user.fullName
    }
    
    func getUserImage() -> String{
        guard let userVm = getUser() else {
            return ""
        }
        return userVm.user.profileImage
    }
    
    private func getUser() -> ProfileViewModel? {
        guard let profileVm = defaults.object(forKey: "profileViewModel") as? Data else {
            return nil
        }
        // READ USERDEFAULTS TO SEE IF THERE IS AN USER LOGGED
        guard let userVm = try? PropertyListDecoder().decode(ProfileViewModel.self, from: profileVm) else {
            return nil
        }
        return userVm
    }
    
    func setUser(fullname: String, email: String, profileimage: String ) {
        // Here the user is created to be saved into the view model and then save the view model into userdefaults
        let userData = User(fullName: fullname, email: email, profileImage: profileimage)
        let profileViewModel = ProfileViewModel(user: userData)
        //aca guardo el viewmodel en el user default
        defaults.set(try? PropertyListEncoder().encode(profileViewModel), forKey: "profileViewModel")
    }
    
    func deleteUserDefault() {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: bundleIdentifier!)
    }
}
