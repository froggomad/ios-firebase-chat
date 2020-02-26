//
//  CreateMessageThreadViewController.swift
//  FireMessage
//
//  Created by Kenny on 2/26/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class CreateMessageThreadViewController: UIViewController {
    @IBOutlet weak var roomNameTextField: UITextField!
    let messageController = MessageController()
    @IBAction func submitButton(_ sender: UIButton) {
        guard let textField = roomNameTextField,
            let roomName = textField.text
        else { return }
        messageController.createRoom(room: Room(roomId: UUID().uuidString,
                                                roomName: roomName,
                                                messages: []))
        self.dismiss(animated: true)
    }
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
