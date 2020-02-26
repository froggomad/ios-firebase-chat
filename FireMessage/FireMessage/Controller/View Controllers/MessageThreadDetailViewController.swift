//
//  MessageThreadDetailViewController.swift
//  FireMessage
//
//  Created by Kenny on 2/25/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import MessageKit
import InputBarAccessoryView

class MessageThreadDetailViewController: MessagesViewController {
    var messageController = MessageController()
    var room: Room = Room(roomId: "ABC123",
                           roomName: "TestName",
                           messages: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageController.fetchMessagesFromRoom(room: room) { error in
            if let error = error {
                print(error)
            } else {
                self.room.messages = self.messageController.messages
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
        let message = room.messages[indexPath.item]
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return room.messages.count
    }
    
}

extension MessageThreadDetailViewController: MessagesLayoutDelegate {
    
}

extension MessageThreadDetailViewController: MessagesDisplayDelegate {
    
}

extension MessageThreadDetailViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(sender: messageController.currentSender, messageText: inputBar.inputTextView.text)
        messageController.createMessageIn(room: self.room, message: message)
        messageController.fetchMessagesFromRoom(room: self.room) { error in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.room.messages = self.messageController.messages
                self.messagesCollectionView.reloadData()
            }
        }
        
        inputBar.inputTextView.text = ""
    }
}
