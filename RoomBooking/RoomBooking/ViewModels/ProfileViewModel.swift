//
//  ProfileViewModel.swift
//  RoomBooking
//
//  Created by Daira Bezzato on 30/09/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation

class ProfileViewModel: Codable {
    let user: User
    
    init(user: User) {
        self.user = user
    }
}
