//
//  Room.swift
//  FireMessage
//
//  Created by Kenny on 2/26/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

struct Room {
    //=======================
    // MARK: - Properties
    let roomId: String
    let roomName: String
    var messages: [Message]
}
