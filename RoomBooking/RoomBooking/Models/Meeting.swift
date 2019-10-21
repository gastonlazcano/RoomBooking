//
//  Meeting.swift
//  RoomBooking
//
//  Created by Daira Bezzato on 26/09/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import Foundation

struct Meeting {
    var title: String
    var date: String
    var time: String
    var room: String
    var answer: State
}

enum State {
    case accepted
    case declined
    case pending
}
