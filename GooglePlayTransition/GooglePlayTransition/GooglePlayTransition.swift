//
//  GooglePlayTransition.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/24.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit

@objc protocol GooglePlayTransitionInterface {
    
    func createTransitionImageView() -> UIImageView
    
    optional
    func createTransitionHeaderImageView() -> UIImageView
    
    optional
    func headerCircleColor() -> UIColor
    
    // Present
    
    optional
    func presentationBeforeAction()
    
    optional
    func presentationAnimationAction(percentComplete: CGFloat)
    
    optional
    func presentationCompletionAction(completeTransition: Bool)
    
    // Dismiss
    
    optional
    func dismissalBeforeAction()
    
    optional
    func dismissalAnimationAction(percentComplete: CGFloat)
    
    optional
    func dismissalCompletionAction(completeTransition: Bool)
}

class GooglePlayTransition {
   
    class func createAnimator(operationType: ARNTransitionAnimatorOperation, fromVC: UIViewController, toVC: UIViewController) -> ARNTransitionAnimator {
        var animator = ARNTransitionAnimator(operationType: operationType, fromVC: fromVC, toVC: toVC)
        
        if let sourceTransition = fromVC as? GooglePlayTransitionInterface, let destinationTransition = toVC as? GooglePlayTransitionInterface {
            
            // Present
            
            animator.presentationBeforeHandler = { [weak fromVC, weak toVC
                , weak sourceTransition, weak destinationTransition](containerView: UIView, transitionContext: UIViewControllerContextTransitioning) in
                containerView.addSubview(fromVC!.view)
                containerView.addSubview(toVC!.view)
                
                toVC!.view.layoutSubviews()
                toVC!.view.layoutIfNeeded()
                
                let sourceImageView = sourceTransition!.createTransitionImageView()
                let destinationImageView = destinationTransition!.createTransitionImageView()
                
                var destinationHeaderImageView = destinationTransition!.createTransitionHeaderImageView?()
                var circleView : UIView?
                
                if let _destinationHeaderImageView = destinationHeaderImageView {
                    containerView.addSubview(_destinationHeaderImageView)
                    _destinationHeaderImageView.image = nil
                    
                    circleView = UIView(frame: CGRectZero)
                    circleView!.clipsToBounds = true
                    let destSize = _destinationHeaderImageView.frame.size
                    if destSize.width >= destSize.height {
                        circleView!.frame.size = CGSizeMake(destSize.width, destSize.width)
                    } else {
                        circleView!.frame.size = CGSizeMake(destSize.height, destSize.height)
                    }
                    circleView!.layer.cornerRadius = circleView!.frame.size.width * 0.5
                    if let circleColor = destinationTransition!.headerCircleColor?() {
                        circleView!.backgroundColor = circleColor
                    } else {
                        circleView!.backgroundColor = UIColor.blueColor()
                    }
                    circleView!.transform = CGAffineTransformMakeScale(0.01, 0.01)
                    
                    let circleSize = circleView!.frame.size
                    circleView!.frame.origin = CGPointMake((destSize.width * 0.5) - (circleSize.width * 0.5), (destSize.height * 0.5) - (circleSize.height * 0.5))
                    
                    _destinationHeaderImageView.addSubview(circleView!)
                }
                
                containerView.addSubview(sourceImageView)
                
                containerView.addSubview(destinationImageView)
                destinationImageView.hidden = true
                
                sourceTransition!.presentationBeforeAction?()
                destinationTransition!.presentationBeforeAction?()
                
                toVC!.view.alpha = 0.0
                
                animator.presentationAnimationHandler = { (containerView: UIView, percentComplete: CGFloat) in
                    sourceImageView.frame = destinationImageView.frame
                    
                    if let _circleView = circleView {
                        _circleView.transform = CGAffineTransformMakeScale(1.2, 1.2)
                    }
                    
                    toVC!.view.alpha = 1.0
                    
                    sourceTransition!.presentationAnimationAction?(percentComplete)
                    destinationTransition!.presentationAnimationAction?(percentComplete)
                }
                
                animator.presentationCompletionHandler = { (containerView: UIView, completeTransition: Bool) in
                    sourceImageView.removeFromSuperview()
                    
                    if let _circleView = circleView {
                        _circleView.removeFromSuperview()
                    }
                    
                    if let _destinationHeaderImageView = destinationHeaderImageView {
                        _destinationHeaderImageView.removeFromSuperview()
                    }
                    
                    sourceTransition!.presentationCompletionAction?(completeTransition)
                    destinationTransition!.presentationCompletionAction?(completeTransition)
                }
            }
            
            // Dismiss
            
            animator.dismissalBeforeHandler = { [weak fromVC, weak toVC
                , weak sourceTransition, weak destinationTransition] (containerView: UIView, transitionContext: UIViewControllerContextTransitioning) in
                containerView.addSubview(toVC!.view)
                containerView.bringSubviewToFront(fromVC!.view)
                
                let sourceImageView = sourceTransition!.createTransitionImageView()
                let destinationImageView = destinationTransition!.createTransitionImageView()
                containerView.addSubview(sourceImageView)
                
                sourceTransition!.dismissalBeforeAction?()
                destinationTransition!.dismissalBeforeAction?()
                
                var sourceHeaderImageView = sourceTransition!.createTransitionHeaderImageView?()
                if let _sourceHeaderImageView = sourceHeaderImageView {
                    containerView.addSubview(_sourceHeaderImageView)
                }
                
                animator.dismissalAnimationHandler = { (containerView: UIView, percentComplete: CGFloat) in
                    sourceImageView.frame = destinationImageView.frame
                    sourceImageView.layer.cornerRadius = destinationImageView.layer.cornerRadius
                    
                    if let _sourceHeaderImageView = sourceHeaderImageView {
                        _sourceHeaderImageView.frame.origin.y -= _sourceHeaderImageView.frame.size.height
                    }
                    
                    sourceTransition!.dismissalAnimationAction?(percentComplete)
                    destinationTransition!.dismissalAnimationAction?(percentComplete)
                }
                
                animator.dismissalCompletionHandler = { (containerView: UIView, completeTransition: Bool) in
                    sourceImageView.removeFromSuperview()
                    
                    if let _sourceHeaderImageView = sourceHeaderImageView {
                        _sourceHeaderImageView.removeFromSuperview()
                    }
                    
                    sourceTransition!.dismissalCompletionAction?(completeTransition)
                    destinationTransition!.dismissalCompletionAction?(completeTransition)
                }
            }
        }
        
        return animator
    }
}
