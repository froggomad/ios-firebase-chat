//
//  Message.swift
//  FireMessage
//
//  Created by Kenny on 2/25/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType, Codable {
    //=======================
    // MARK: - Properties
    var messageId: String
    var messageText: String
    var senderName: String
    var sentDate: Date
    
    init(sender: Sender, messageText: String, sentDate: Date? = nil) {
        self.messageId = UUID().uuidString
        self.messageText = messageText
        self.senderName = sender.displayName
        
        
        if let sentDate = sentDate {
            self.sentDate = sentDate
        } else {
            self.sentDate = Date()
        }
    }
    
    //Computed Properties
    var sender: SenderType {
        return Sender(senderId: messageId, displayName: senderName)
    }
    
    var kind: MessageKind {
        return .text(messageText)
    }
    
    var formattedStringFromDate: String {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df.string(from: sentDate)
    }
}

//=======================
// MARK: - Dependencies
struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
