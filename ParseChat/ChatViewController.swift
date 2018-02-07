//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Nikhil Iyer on 1/29/18.
//  Copyright © 2018 Nikhil Iyer. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatMessageField: UITextField!
    
    @IBOutlet weak var ChatTableView: UITableView!
    
    
    var messageSaveSucess = "Hi";
    
    var messages: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages = [];
        
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        
        ChatTableView.rowHeight = UITableViewAutomaticDimension
        ChatTableView.estimatedRowHeight = 50
        ChatTableView.separatorStyle = .none;
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let message = self.messages[indexPath.row]
        
        let m = message["text"] as? String
        
        cell.chatLabel.text = "✉️: \(m!)"
        
        if let user = message["user"] as? String {
            // User found! update username label with username
            cell.usernameLabel.text = "📱: \(user)"
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        
        return cell;
    }
   
    @IBAction func send(_ sender: Any) {
        let chatMessage = PFObject(className: "Message");
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage["user"] = PFUser.current()!.username!
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageSaveSucess = "Success";
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
    }
    
    func onTimer() {
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground { (messages, error) in
            if let error = error{
                print("Problem saving message: \(error.localizedDescription)")
            }
            else{
                self.messages = messages
                self.ChatTableView.reloadData()
            }
            
        }
    }
    @IBAction func logout(_ sender: Any) {
//        PFUser.logOut()
//        self.dismiss(animated: true, completion: nil)
//        self.performSegue(withIdentifier: "backToLogin", sender: nil)
    
        //NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
        
        
        
        PFUser.logOut()
        print("User has been logged out")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        present(viewController!, animated: true, completion: nil)
           }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
