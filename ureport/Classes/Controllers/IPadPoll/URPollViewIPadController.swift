//
//  URPollViewIPadController.swift
//  ureport
//
//  Created by Daniel Amaral on 28/04/16.
//  Copyright © 2016 ilhasoft. All rights reserved.
//

import UIKit

class URPollViewIPadController: UIViewController, URClosedPollTableViewControllerDelegate {
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var contentLeftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightViewLoad: UIView!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var imgMessage: UIImageView!
    
    var poll:URPoll?
    var pollContributionModal = URPollContributionModalViewController()
    
    init() {
        super.init(nibName: "URPollViewIPadController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let closedPollTableViewController = URClosedPollTableViewController()
    let challengeDetailViewController = URChallengeDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closedPollTableViewController.delegate = self
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.leftView.setNeedsLayout()
        self.leftView.layoutIfNeeded()
        
        self.rightView.setNeedsLayout()
        self.rightView.layoutIfNeeded()
        
        self.contentLeftView.setNeedsLayout()
        self.contentLeftView.layoutIfNeeded()
        
        closedPollTableViewController.view.frame = CGRect(x: 0, y: 0, width: contentLeftView.bounds.size.width, height: contentLeftView.bounds.size.height)
        closedPollTableViewController.tableView.contentSize = CGSize(width: contentLeftView.bounds.size.width, height: closedPollTableViewController.tableView.contentSize.height)
//        pollResultTableViewController.view.frame = CGRect(x: 0, y: 0, width: rightView.bounds.size.width, height: rightView.bounds.size.height)
        challengeDetailViewController.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 50, right: 0)
        closedPollTableViewController.onBoundsChanged()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: false)
        URNavigationManager.setupNavigationBarWithCustomColor(URCountryProgramManager.activeCountryProgram()!.themeColor!)
    }
    
    //MARK: URClosedPollTableViewControllerDelegate
    
    func tableViewCellDidTap(cell: URClosedPollTableViewCell, isIPad:Bool) {
        self.rightViewLoad.hidden = true
        self.poll = cell.poll
        pollContributionModal.poll = poll
        self.lbMessage.hidden = true
        self.imgMessage.hidden = true
        challengeDetailViewController.poll = poll
        challengeDetailViewController.setupData()
    }
    
    //MARK: Button Events
    
    @IBAction func btCommentTapped(sender: AnyObject) {
        pollContributionModal.show(true, inViewController: self)
    }
    
    
    //MARK: Class Methods
    
    func displayLeftContentController(content: UIViewController) {
        self.addChildViewController(content)
        content.view.frame = CGRect(x: 0, y: 0, width: contentLeftView.bounds.size.width, height: contentLeftView.bounds.size.height)
        content.view.backgroundColor = UIColor.clearColor()
        self.contentLeftView.addSubview(content.view)
        content.didMoveToParentViewController(self)
    }
    
    func displayRightContentController(content: UIViewController) {
        self.addChildViewController(content)
        content.view.frame = CGRect(x: 0, y: 0, width: rightView.bounds.size.width, height: rightView.bounds.size.height - 50)
        self.rightView.insertSubview(content.view, atIndex: 0)
        content.didMoveToParentViewController(self)
    }
    
    func setupUI() {        
        displayLeftContentController(closedPollTableViewController)
        displayRightContentController(challengeDetailViewController)
        challengeDetailViewController.tableView.alwaysBounceVertical = false
    }
    
}

