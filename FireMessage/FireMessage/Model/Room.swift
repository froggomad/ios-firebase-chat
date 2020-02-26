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
    // MARK: - Types
    enum FirebaseKeys: String {
        case roomId
        case roomName
        case messages
    }
    //=======================
    // MARK: - Properties
    var roomId: String
    var roomName: String
    var messages: [Message]
    
    var roomData: [String:Any] {
        var rmDict = [String:Any]()
        rmDict[FirebaseKeys.roomId.rawValue] = roomId
        rmDict[FirebaseKeys.roomName.rawValue] = roomName
        return rmDict
    }
}
