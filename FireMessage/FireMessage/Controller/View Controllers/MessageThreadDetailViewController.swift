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
    //=======================
    // MARK: - Properties
    var messageController: MessageController?
    var room: Room? {
        didSet {
            if isViewLoaded {
                assignMessages()
            }
        }
    }
    var messages: [Message] = []
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        guard let room = room else { return }
        messageController?.fetchMessagesFromRoom(room: room) { error in
            if let error = error {
                print(error)
            } else {
                self.assignMessages()
            }
        }
    }
    
    func assignMessages() {
        guard let messageController = messageController else { return }
        if messageController.messages.count >= 2 {
            messages = messageController.messages.sorted { $0.sentDate < $1.sentDate }
            messagesCollectionView.reloadData()
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        //Room -> Encode -> Data ->
        let roomData = try? PropertyListEncoder().encode(room)
        coder.encode(roomData, forKey: "roomData")
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        // Data -> Decode -> Room -> setup view
        guard let roomData = coder.decodeObject(forKey: "roomData") as? Data else { return }
        do {
            room = try PropertyListDecoder().decode(Room.self, from: roomData)
        } catch {
            print("error decoding: ", error)
        }
    }
}

extension MessageThreadDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return messageController?.currentSender ?? Sender(senderId: "nil", displayName: "Error")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = messages[indexPath.item]
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}

extension MessageThreadDetailViewController: MessagesLayoutDelegate {
    
}

extension MessageThreadDetailViewController: MessagesDisplayDelegate {
    
}

extension MessageThreadDetailViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let messageController = messageController,
            let room = room
        else { return }
        
        let message = Message(sender: messageController.currentSender, messageText: inputBar.inputTextView.text)
        messageController.createMessageIn(room: room, message: message)
        messageController.fetchMessagesFromRoom(room: room) { error in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.assignMessages()
            }
        }
        inputBar.inputTextView.text = ""
    }
}
