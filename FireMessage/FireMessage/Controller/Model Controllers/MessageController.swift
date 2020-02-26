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
    var rooms = [Room]()
    
    //=======================
    // MARK: - Create/Update
    func createRoom(room: Room) {
        DB.updateChildValues([room.roomId:room.roomData])
    }
    
    func createMessageIn(room: Room, message: Message) {
        DB.child(room.roomId).updateChildValues([message.messageId:message.messageData])
    }
    
    //=======================
    // MARK: - Read
    func fetchRooms(complete: @escaping (Error?) -> ()) {
        DB.observeSingleEvent(of: .value) { (roomsSnapshot) in
            guard let roomsSnapshot = roomsSnapshot.children.allObjects as? [DataSnapshot] else {return}
            var valueDict = [String:Any]()
            for value in roomsSnapshot {
                valueDict[value.key] = value.value
            }
            if !valueDict.isEmpty {
                if valueDict.count == roomsSnapshot.count {
                    self.rooms = []
                    _ = valueDict.map {
                        var room = Room(roomId: "1", roomName: "no", messages: [])
                        if let dict = $0.value as? [String:Any] {
                            for (key, value) in dict {
                                switch key {
                                case Room.FirebaseKeys.roomId.rawValue:
                                    room.roomId = value as! String
                                case Room.FirebaseKeys.roomName.rawValue:
                                    room.roomName = value as! String
                                default: break
                                }
                            }
                        }
                        if room.roomId != "1" {
                            self.rooms.append(room)
                        }
                    }
                    complete(nil)
                }  else {
                    let error = NSError(domain: "DataService.fetchRooms.valueDict.count", code: 999)
                    complete(error)
                }
            } else {
                let error = NSError(domain: "DataService.fetchRooms.downloadFailed", code: 404)
                complete(error)
            }
        }
    }
    
    func fetchMessagesFromRoom(room: Room, complete: @escaping (Error?) -> ()) {
        DB.child(room.roomId).observeSingleEvent(of: .value) { (tableSnapshot) in
            guard let tableSnapshot = tableSnapshot.children.allObjects as? [DataSnapshot] else {return}
            var valueDict = [String:Any]()
            for value in tableSnapshot {
                valueDict[value.key] = value.value
            }
            if !valueDict.isEmpty {
                if valueDict.count == tableSnapshot.count {
                    self.messages = []
                    _ = valueDict.map {
                        var message: Message = Message(sender: self.currentSender,
                                                       messageText: "")
                        if let dict = $0.value as? [String:String] {
                            for (key,value) in dict {
                                switch key {
                                case Message.FirebaseKeys.messageId.rawValue:
                                    message.messageId = value
                                case Message.FirebaseKeys.messageText.rawValue:
                                    message.messageText = value
                                case Message.FirebaseKeys.senderName.rawValue:
                                    message.senderName = value
                                case Message.FirebaseKeys.senderId.rawValue:
                                    message.senderId = value
                                case Message.FirebaseKeys.sentDate.rawValue:
                                    let df = DateFormatter()
                                    df.locale = .current
                                    df.dateFormat = "MM/dd/yyyy hh:mm:ss"
                                    if let date = df.date(from: value) {
                                        message.sentDate = date
                                    }
                                default: break
                                }
                            }
                            self.messages.append(message)
                        }
                    }
                    print(self.messages)
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
