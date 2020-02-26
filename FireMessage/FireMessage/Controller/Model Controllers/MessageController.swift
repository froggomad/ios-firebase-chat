//
//  MessageController.swift
//  FireMessage
//
//  Created by Kenny on 2/25/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MessageController {
    let DB = Database.database().reference()
    var SENDER_REF: DatabaseReference {
        return DB.child(currentSender.senderId)
    }
    
    var currentSender: Sender {
        return Sender(senderId: "Admin", displayName: "Kenny")
    }
    var messages = [Message]()
    
    func createMessage(message: Message) {
        SENDER_REF.updateChildValues([message.sender.senderId:message.messageId])
    }
    
    func deleteMessage(message: Message) {
        SENDER_REF.child(message.sender.senderId).removeValue()
    }
}
