//
//  MessageThreadTableViewController.swift
//  FireMessage
//
//  Created by Kenny on 2/26/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class MessageThreadTableViewController: UITableViewController {
    //=======================
    // MARK: - Types
    enum Identifier: String {
        case roomCellSegue = "RoomCellTapped"
        case addRoomSegue = "AddRoomSegue"
    }
    
    //=======================
    // MARK: - Properties
    var rooms = [Room]()
    var messageController = MessageController()
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messageController.fetchRooms { (error) in
            if let error = error {
                print(error)
            }
            self.rooms = self.messageController.rooms
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageController.rooms.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
    
    //=======================
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Identifier.addRoomSegue.rawValue:
            guard let destination = segue.destination as? CreateMessageThreadViewController else { return }
            
        case Identifier.roomCellSegue.rawValue:
            guard let destination = segue.destination as? MessageThreadDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
            else { return }
            destination.messageController = messageController
            destination.room = rooms[indexPath.row]
        default: fatalError("Create identifier to match \(String(describing: segue.identifier)) in enum")
        }
     
     }
    
}
