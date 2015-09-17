//
//  ModalViewController.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/22.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class ModalViewController: GooglePlayTransitionViewController, GooglePlayTransitionInterface {
    
    @IBOutlet weak var tableView : UITableView!
    
    var headerView : HeaderView!
    
    deinit {
        print("deinit ModalViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "ModalCell", bundle: nil), forCellReuseIdentifier: "ModalCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.headerView = UINib(nibName: "HeaderView", bundle: NSBundle.mainBundle()).instantiateWithOwner(nil, options: nil)[0] as! HeaderView
        headerView.tapButtonHandler = { [weak self] in
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.tableView.tableHeaderView = self.headerView
    }
    
    // MARK: - GooglePlayTransitionInterface
    
    func createTransitionImageView() -> UIImageView {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath) as! ModalCell
        let imageView = UIImageView(image: cell.cellImageView.image)
        imageView.contentMode = cell.cellImageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = cell.cellImageView.convertRect(cell.cellImageView.bounds, toView: self.view)
        
        return imageView
    }
    
    func createTransitionHeaderImageView() -> UIImageView {
        let imageView = UIImageView(image: self.headerView.imageView.image)
        imageView.contentMode = self.headerView.imageView.contentMode
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.frame = headerView.imageView.frame

        return imageView;
    }
    
    func headerCircleColor() -> UIColor {
        return self.headerView.backgroundColor!
    }
    
    func presentationBeforeAction() {
        self.headerView.imageView.alpha = 0.0
        self.tableView.alpha = 0.0
    }
    
    func presentationCompletionAction(completeTransition: Bool) {
        self.tableView.alpha = 1.0
        
        UIView.animateWithDuration(
            0.28,
            delay: 0.05,
            options: [.TransitionCrossDissolve, .CurveLinear],
            animations: {
                self.headerView.imageView.alpha = 1.0
            },
            completion: nil
        )
    }
    
    func dismissalBeforeAction() {
        self.view.backgroundColor = UIColor.clearColor()
        self.headerView.hidden = true
        
        // FIXME : reusableCell imageView hidden
        for cell in self.tableView.visibleCells {
            if cell is ModalCell {
                let headCell = cell as! ModalCell
                headCell.cellImageView.hidden = true
            }
        }
    }
    
    func dismissalAnimationAction(percentComplete: CGFloat) {
        self.tableView.frame.origin.y = self.view.frame.size.height
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ModalCell", forIndexPath: indexPath) as! ModalCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) 
        
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        return 80
    }
}
