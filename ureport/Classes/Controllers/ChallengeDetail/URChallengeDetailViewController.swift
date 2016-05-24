//
//  URChallengeDetailViewController.swift
//  honeybee
//
//  Created by Daniel Amaral on 23/05/16.
//  Copyright © 2016 ilhasoft. All rights reserved.
//

import UIKit

class URChallengeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segmentedControl:UISegmentedControl!
    @IBOutlet weak var tableView:UIExpandableTableView!
    
    @IBOutlet weak var viewResult:UIView!
    @IBOutlet weak var viewChallenge:UIView!
    
    @IBOutlet weak var lbPollName: UILabel!
    @IBOutlet weak var lbPollArea: UILabel!
    
    let pollResultController = URPollResultViewController()
    
    var poll:URPoll!
    var items:[[String]] = []
    
    init() {
        super.init(nibName: "URChallengeDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupData()
    }

    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (!items.isEmpty) {
            if (self.tableView.sectionOpen != NSNotFound && section == self.tableView.sectionOpen) {
                return items[section].count - 1
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(URChallengeDetailTableViewCell.self), forIndexPath: indexPath) as! URChallengeDetailTableViewCell
        
        cell.lbContent.text = self.items[indexPath.section][1]
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {        
        let headerView = HeaderView(tableView: self.tableView, section: section)
        headerView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: headerView.frame.size.width - 16 , height: headerView.frame.size.height))
        label.text = self.items[section][0]
        label.textAlignment = NSTextAlignment.Left
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.textColor = UIColor.blackColor()
        
        headerView.addSubview(label)
        
        let viewSeparator = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height - 1, width: headerView.frame.size.width, height: 1))
        viewSeparator.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        headerView.addSubview(viewSeparator)
        
        if section == 0 {
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(timerToggle), userInfo: headerView, repeats: false)
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: Events
    
    
    @IBAction func segmentedControlDidChange(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.viewResult.hidden = true
            self.viewChallenge.hidden = false
            break
        case 1:
            self.viewChallenge.hidden = true
            self.viewResult.hidden = false
            break
        default:
            break
        }
        
    }
    
    //MARK: Class Methods
    
    func timerToggle(timer:NSTimer) {
        (timer.userInfo as! HeaderView).toggle()
    }
    
    func setupUI() {
        displayChildController(pollResultController)
    }
    
    func displayChildController(content: UIViewController) {
        self.addChildViewController(content)
        content.view.frame = CGRect(x: 0, y: 0, width: viewResult.bounds.size.width, height: viewResult.bounds.size.height)
        self.viewResult.insertSubview(content.view, atIndex: 0)
        content.didMoveToParentViewController(self)
    }
    
    func setupData() {
        
        pollResultController.poll = poll
        
        self.lbPollName.text = poll.title
        self.lbPollArea.text = poll.category.name
        
        for i in 0 ..< 3 {
            switch i {
            case 0:
                items.append(["Problem/Issue"])
                if let issue = poll.issue {
                    items[0].append(issue)
                }
                break
            case 1:
                items.append(["Need"])
                if let need = poll.need {
                    items[1].append(need)
                }
                break
            case 2:
                items.append(["Expected Outcome"])
                if let expected_outcome = poll.expected_outcome {
                    items[2].append(expected_outcome)
                }
                break
            default:
                break
            }
        }
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 50;
        self.tableView.registerNib(UINib(nibName: "URChallengeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: NSStringFromClass(URChallengeDetailTableViewCell.self))
        self.tableView.separatorColor = UIColor.clearColor()
    }

    //MARK: Buton Events
    
    @IBAction func btEnterTapped(button:UIButton) {
        if let chatRoomKey = poll.chat_room {
            ProgressHUD.show(nil)
            URChatRoomManager.getByKey(chatRoomKey, completion: { (chatRoom) in
                let groupChatRoom = chatRoom as! URGroupChatRoom
                URChatMemberManager.getChatMembersByChatRoomWithCompletion(chatRoomKey, completionWithUsers: { (users:[URUser]) in
                    ProgressHUD.dismiss()
                    self.navigationController?.pushViewController(URMessagesViewController(chatRoom: chatRoom, chatMembers: users, title: groupChatRoom.title), animated: true)
                })
                
            })
        }else {
//            self.navigationController?.pushViewController(URMessagesViewController(chatRoom: chatRoom, chatMembers: users, title: groupChatRoom.title), animated: true)
        }
    }

}
