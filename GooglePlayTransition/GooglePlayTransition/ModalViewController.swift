//
//  ModalViewController.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/22.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

final class ModalViewController: UIViewController, GooglePlayTransitionInterface, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    
    var headerView : HeaderView!
    
    deinit {
        print("deinit ModalViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ModalCell", bundle: nil), forCellReuseIdentifier: "ModalCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.headerView = UINib(nibName: "HeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? HeaderView
        headerView.tapButtonHandler = { [weak self] in
            self!.dismiss(animated: true, completion: nil)
        }
        
        self.tableView.tableHeaderView = self.headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ModalViewController viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ModalViewController viewWillDisappear")
    }
    
    // MARK: - GooglePlayTransitionInterface
    
    func createTransitionImageView() -> UIImageView {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as! ModalCell
        let imageView = UIImageView(image: cell.cellImageView.image)
        imageView.contentMode = cell.cellImageView.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.frame = cell.cellImageView.convert(cell.cellImageView.bounds, to: self.view)
        
        return imageView
    }
    
    func createTransitionHeaderImageView() -> UIImageView {
        let imageView = UIImageView(image: self.headerView.imageView.image)
        imageView.contentMode = self.headerView.imageView.contentMode
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.frame = headerView.imageView.frame
        if #available(iOS 11.0, *) {
            imageView.frame.origin.y += self.view.safeAreaInsets.top
        }

        return imageView;
    }
    
    func headerCircleColor() -> UIColor {
        return self.headerView.backgroundColor!
    }
    
    func presentationBeforeAction() {
        self.headerView.imageView.alpha = 0.0
        self.tableView.alpha = 0.0
    }
    
    func presentationCompletionAction(_ completeTransition: Bool) {
        self.tableView.alpha = 1.0
        
        UIView.animate(
            withDuration: 0.28,
            delay: 0.05,
            options: [.transitionCrossDissolve, .curveLinear],
            animations: {
                self.headerView.imageView.alpha = 1.0
            },
            completion: nil
        )
    }
    
    func dismissalBeforeAction() {
        self.view.backgroundColor = UIColor.clear

        // FIXME : reusableCell imageView hidden
        for cell in self.tableView.visibleCells {
            if cell is ModalCell {
                let headCell = cell as! ModalCell
                headCell.cellImageView.isHidden = true
            }
        }
    }
    
    func dismissalAnimationAction(_ percentComplete: CGFloat) {
        self.tableView.frame.origin.y = self.view.frame.size.height
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModalCell", for: indexPath as IndexPath) as! ModalCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath as IndexPath)
        
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        return 80
    }
}
