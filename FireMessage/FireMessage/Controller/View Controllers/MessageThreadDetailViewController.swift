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
    let message = Message(sender: Sender(senderId: "123", displayName: "Me"), messageText: "Test")
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageController.deleteMessage(message: message)
    }
    
    
}

extension MessageThreadDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return messageController.currentSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = messageController.messages[indexPath.item]
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
