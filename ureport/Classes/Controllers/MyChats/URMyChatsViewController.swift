//
//  URMyChatsViewController.swift
//  ureport
//
//  Created by Daniel Amaral on 15/09/15.
//  Copyright (c) 2015 ilhasoft. All rights reserved.
//

import UIKit

class URMyChatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btSee: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescriptionOpenGroups: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var listChatRoom:[URChatRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        URNavigationManager.setupNavigationBarWithCustomColor(URCountryProgramManager.activeCountryProgram()!.themeColor!)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)    
    }
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listChatRoom.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(URChatTableViewCell.self), forIndexPath: indexPath) as! URChatTableViewCell
        
        cell.setupCellWithChatRoomList(self.listChatRoom, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! URChatTableViewCell
                
        if let chatRoom = cell.chatRoom {
            ProgressHUD.show(nil)
            URGCMManager.registerUserInTopic(URUser.activeUser()!, chatRoom: chatRoom)
            URChatMemberManager.getChatMembersByChatRoomWithCompletion(chatRoom.key, completionWithUsers: { (users) -> Void in
                ProgressHUD.dismiss()
                
                var chatName = ""
                
                if chatRoom is URIndividualChatRoom {
                    chatName = (chatRoom as! URIndividualChatRoom).friend.nickname
                }else if chatRoom is URGroupChatRoom {
                    chatName = (chatRoom as! URGroupChatRoom).title
                }
                
                self.navigationController?.pushViewController(URMessagesViewController(chatRoom: chatRoom,chatMembers:users,title:chatName), animated: true)
            })
        }
        
    }

    //MARK: Button Events
    
    @IBAction func btSeeTapped(sender: AnyObject) {
        self.navigationController?.pushViewController(URGroupsTableViewController(), animated: true)
    }
    
    
    //MARK: Class Methods
    
    func setupUI() {
        btSee.layer.cornerRadius = 4
        self.tableView.backgroundColor = URConstant.Color.WINDOW_BACKGROUND
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.registerNib(UINib(nibName: "URChatTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(URChatTableViewCell.self))
    }
    
    func loadData() {
        if listChatRoom.count == 0 {
            ProgressHUD.show(nil)
        }
        URChatRoomManager.getChatRooms(URUser.activeUser()!, completion: { (chatRooms:[URChatRoom]?) -> Void in
            ProgressHUD.dismiss()
            if chatRooms != nil {
                self.listChatRoom = chatRooms!
                
                self.tableView.reloadData()
            }
        })
    }
    
}