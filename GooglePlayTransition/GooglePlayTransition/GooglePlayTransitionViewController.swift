//
//  GooglePlayTransitionViewController.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/24.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

class GooglePlayTransitionViewController: UIViewController, UIViewControllerTransitioningDelegate  {
   
    weak var fromVC : UIViewController?
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = GooglePlayTransition.createAnimator(.Present, fromVC: source, toVC: presented)
        self.fromVC = source
        
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = GooglePlayTransition.createAnimator(.Dismiss, fromVC: self, toVC: self.fromVC!)
        
        return animator
    }
}
