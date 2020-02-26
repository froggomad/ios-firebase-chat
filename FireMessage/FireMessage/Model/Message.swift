//
//  Message.swift
//  FireMessage
//
//  Created by Kenny on 2/25/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    //=======================
    // MARK: - Types
    enum FirebaseKeys: String {
        case messageId
        case messageText
        case senderName
        case senderId
        case sentDate
    }
    
    //=======================
    // MARK: - Properties
    var messageId: String
    var messageText: String
    var senderName: String
    var senderId: String
    var sentDate: Date
    
    init(sender: Sender, messageText: String, sentDate: Date? = nil) {
        self.messageId = UUID().uuidString
        self.messageText = messageText
        self.senderName = sender.displayName
        self.senderId = sender.senderId
        
        if let sentDate = sentDate {
            self.sentDate = sentDate
        } else {
            self.sentDate = Date()
        }
    }
    
    //Computed Properties
    var sender: SenderType {
        return Sender(senderId: "123", displayName: senderName)
    }
    
    var kind: MessageKind {
        return .text(messageText)
    }
    
    var formattedStringFromDate: String {
        let df = DateFormatter()
        df.locale = .current
        df.dateFormat = "MM/dd/yyyy hh:mm:ss"
        return df.string(from: sentDate)
    }
    
    var messageData: [String:Any] {
        var msgDict = [String:Any]()
        msgDict[FirebaseKeys.messageText.rawValue] = messageText
        msgDict[FirebaseKeys.senderName.rawValue] = senderName
        msgDict[FirebaseKeys.sentDate.rawValue] = formattedStringFromDate
        msgDict[FirebaseKeys.senderId.rawValue] = senderId
        return msgDict
    }
}

//=======================
// MARK: - Dependencies
struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
