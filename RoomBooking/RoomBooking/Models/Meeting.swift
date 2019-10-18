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
    var date: String //Esto hay que ver como lo trae el don google
    var time: String // aca tambien hay que ver si dat + time no son uno solito
    var room: String // Lo mismo acá, a ver como lo trae don google
    var answer: State //Esta es la respuesta a la meeting
}

enum State {
    case accepted
    case declined
    case pending
}
