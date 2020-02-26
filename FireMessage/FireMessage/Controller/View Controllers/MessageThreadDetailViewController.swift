//
//  MessageThreadDetailViewController.swift
//  FireMessage
//
//  Created by Kenny on 2/25/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import MessageKit

class MessageThreadDetailViewController: MessagesViewController {
    var messageController = MessageController()
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        let message = Message(sender: Sender(senderId: "123", displayName: messageController.currentSender.displayName), messageText: "Test")
        let room = Room(roomId: "ABC123",
                        roomName: "TestName",
                        messages: [message])
        messageController.createMessageIn(room: room, message: message)
        messageController.fetchMessagesFromRoom(room: room) { error in
            if let error = error {
                print(error)
            } else {
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
    
}

extension MessageThreadDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return messageController.currentSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = messageController.messages[indexPath.section]
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageController.messages.count
    }
    
}

extension MessageThreadDetailViewController: MessagesLayoutDelegate {
    
}

extension MessageThreadDetailViewController: MessagesDisplayDelegate {
    
}
