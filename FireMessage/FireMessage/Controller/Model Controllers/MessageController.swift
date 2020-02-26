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
    //=======================
    // MARK: - DB References
    let DB = Database.database().reference()
    
    //=======================
    // MARK: - Properties
    var currentSender: Sender {
        return Sender(senderId: "ABC123", displayName: "Kenny")
    }
    var messages = [Message]()
    
    //=======================
    // MARK: - Create/Update
    func createMessageIn(room: Room, message: Message) {
        DB.child(room.roomId).updateChildValues([message.messageId:message.messageData])
    }
    
    //=======================
    // MARK: - Read
    func fetchMessagesFromRoom(room: Room, complete: @escaping (Error?) -> ()) {
        DB.child(room.roomId).observeSingleEvent(of: .value) { (tableSnapshot) in
            guard let tableSnapshot = tableSnapshot.children.allObjects as? [DataSnapshot] else {return}
            var valueDict = [String:Any]()
            for value in tableSnapshot {
                valueDict[value.key] = value.value
            }
            if !valueDict.isEmpty {
                if valueDict.count == tableSnapshot.count {
                    _ = valueDict.map {
                        var message: Message = Message(sender: self.currentSender,
                                                       messageText: "")
                        if let dict = $0.value as? [String:Any] {
                            for (key,value) in dict {
                                switch key {
                                case Message.FirebaseKeys.messageId.rawValue:
                                    message.messageId = value as! String
                                case Message.FirebaseKeys.messageText.rawValue:
                                    message.messageText = value as! String
                                case Message.FirebaseKeys.senderName.rawValue:
                                    message.senderName = value as! String
                                case Message.FirebaseKeys.senderId.rawValue:
                                    message.senderId = value as! String
                                case Message.FirebaseKeys.sentDate.rawValue:
                                    let df = DateFormatter()
                                    df.dateStyle = .short
                                    df.timeStyle = .short
                                    if let date = df.date(from: value as! String) {
                                        message.sentDate = date
                                    }
                                    default: break
                                }
                            }
                            self.messages.append(message)
                            
                        }
                        
                    }
                    complete(nil)
                } else {
                    let error = NSError(domain: "DataService.fetchMessages.valueDict.count", code: 999)
                    complete(error)
                }
            } else {
                let error = NSError(domain: "DataService.fetchMessages.downloadFailed", code: 404)
                complete(error)
            }
        }
    }
    
    //=======================
    // MARK: - Delete
    func deleteMessageFrom(room: Room, message: Message) {
        DB.child(room.roomId).child(message.sender.senderId).removeValue()
    }
}
