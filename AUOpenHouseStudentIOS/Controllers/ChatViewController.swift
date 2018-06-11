//
//  ChatViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 11/6/2561 BE.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var tb_chats: UITableView!
    @IBOutlet weak var cs_tfButtom: NSLayoutConstraint!
    @IBOutlet weak var tf_message: UITextField!
    
    public var event: Event?
    public var userName: String = "unknow"

    var ref: DatabaseReference!
    var handle: UInt?
    var authHandle: AuthStateDidChangeListenerHandle?
    
    struct Chat {
        var message: String = ""
        var userName: String = ""
        var specialMessage: Bool = false
    }
    
    var chats = [Chat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        tf_message.delegate = self
        tb_chats.dataSource = self
        tb_chats.delegate = self
        
        addKeyboardObserve()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUser()
        getChats()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Remove Handel
        leaveChat()
        Auth.auth().removeStateDidChangeListener(authHandle!)
        ref.child("Chats/Events/\(event?.eid ?? 0)").removeObserver(withHandle: handle!)
    }
    
    @IBAction func onSendClick(_ sender: UIButton) {
        sendMessage()
    }
    
}

extension ChatViewController {
    // Chat
    func getUser(){
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if(user == nil){
                // user not login, show loginViewController
                print("Firebase: not login")
                
            }else{
                // user already logged in firebase
                print("Firebase: logged in")
                
                self.userName = (user?.displayName!)!
                self.enterChat()
            }
        }
    }
    
    func enterChat(){
        let post = [
            "specialMessage": true,
            "message": "\(userName) has joined the chat"
            ] as [String : Any]
        self.ref.child("Chats/Events/\(event?.eid ?? 0)").childByAutoId().setValue(post)
    }
    
    func leaveChat(){
        let post = [
            "specialMessage": true,
            "message": "\(userName) has left the chat"
            ] as [String : Any]
        self.ref.child("Chats/Events/\(event?.eid ?? 0)").childByAutoId().setValue(post)
    }
    
    func sendMessage(){
        if tf_message.text?.isEmpty ?? true {
            return
        }
        
        let post = [
            "username": self.userName,
            "message": self.tf_message.text!
            ] as [String : Any]
        self.ref.child("Chats/Events/\(event?.eid ?? 0)").childByAutoId().setValue(post)
        
        tf_message.text = ""
    }
    
    func getChats(){
        self.handle = ref.child("Chats/Events/\(event?.eid ?? 0)").observe(.value) { (snapshot) in
            if snapshot.exists() {
                
                self.chats.removeAll()
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshot {
                        if let chatData = snap.value as? [String:AnyObject]{
                            
                            var tC = Chat()
                            
                            tC.specialMessage = chatData["specialMessage"] as? Bool ?? false
                            tC.userName = chatData["username"] as? String ?? ""
                            tC.message = chatData["message"] as? String ?? ""
                            
                            self.chats.append(tC)
                            
                        }
                    }
                    
                    DispatchQueue.main.async {
                        print("new chat loaded")
                        self.tb_chats.reloadData()
                        self.tb_chats.scrollToRow(at: IndexPath(row: self.chats.count-1, section: 0), at: .bottom, animated: true)
                    }
                }
            }
        }
    }
    
}

extension ChatViewController: UITextFieldDelegate {
    // Keyboard
    
    func addKeyboardObserve(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        sendMessage()
        
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            let rect = (info["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.cs_tfButtom.constant = -1 * rect.height
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.cs_tfButtom.constant = 0
        }
    }
    
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TODO - check message from user or others
        
        if chats[indexPath.row].specialMessage {
            // If non message - join & leave events
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
           
            cell.textLabel?.text = chats[indexPath.row].message
            cell.textLabel?.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            return cell
            
        } else {
            if chats[indexPath.row].userName != userName {
                // from others
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellChatOther", for: indexPath) as! ChatOtherTableViewCell
                
                cell.lb_otherName.text = chats[indexPath.row].userName
                cell.tv_otherMessage.text = chats[indexPath.row].message
                
                return cell
            } else {
                // from user
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellChatUser", for: indexPath) as! ChatUserTableViewCell
                
                cell.lb_userName.text = chats[indexPath.row].userName
                cell.tv_userMessage.text = chats[indexPath.row].message
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}


