//
//  GooglePlayTransitionAnimation.swift
//  GooglePlayTransition
//
//  Created by xxxAIRINxxx on 2015/08/24.
//  Copyright (c) 2015 xxxAIRINxxx. All rights reserved.
//

import UIKit
import ARNTransitionAnimator

protocol GooglePlayTransitionInterface: UIViewController {
    
    func createTransitionImageView() -> UIImageView

    func createTransitionHeaderImageView() -> UIImageView

    func headerCircleColor() -> UIColor
    
    // Present

    func presentationBeforeAction()

    func presentationAnimationAction(_ percentComplete: CGFloat)

    func presentationCompletionAction(_ completeTransition: Bool)
    
    // Dismiss

    func dismissalBeforeAction()

    func dismissalAnimationAction(_ percentComplete: CGFloat)

    func dismissalCompletionAction(_ completeTransition: Bool)
}

// optional
extension GooglePlayTransitionInterface {

    func createTransitionHeaderImageView() -> UIImageView {
        return UIImageView()
    }

    func headerCircleColor() -> UIColor {
        return UIColor.white
    }

    func presentationBeforeAction() {}

    func presentationAnimationAction(_ percentComplete: CGFloat) {}

    func presentationCompletionAction(_ completeTransition: Bool) {}

    func dismissalBeforeAction() {}

    func dismissalAnimationAction(_ percentComplete: CGFloat) {}

    func dismissalCompletionAction(_ completeTransition: Bool) {}
}

final class GooglePlayTransitionAnimation : TransitionAnimatable {

    deinit {
        print("deinit GooglePlayTransitionAnimation")
    }

    fileprivate weak var rootVC: GooglePlayTransitionInterface!
    fileprivate weak var modalVC: GooglePlayTransitionInterface!

    fileprivate var circleView : UIView?
    fileprivate var sourceImageView: UIImageView?
    fileprivate var sourceHeaderImageView: UIImageView?
    fileprivate var destinationImageView: UIImageView?
    fileprivate var destinationHeaderImageView: UIImageView?

    init(rootVC: GooglePlayTransitionInterface, modalVC: GooglePlayTransitionInterface) {
        self.rootVC = rootVC
        self.modalVC = modalVC
    }

    func willAnimation(_ transitionType: TransitionType, containerView: UIView) {
        if transitionType.isPresenting {
            sourceImageView = rootVC.createTransitionImageView()
            destinationImageView = modalVC.createTransitionImageView()
            destinationHeaderImageView = modalVC.createTransitionHeaderImageView()

            if let _destinationHeaderImageView = destinationHeaderImageView {
                containerView.addSubview(_destinationHeaderImageView)
                _destinationHeaderImageView.image = nil

                circleView = UIView(frame: CGRect.zero)
                circleView!.clipsToBounds = true
                let destSize = _destinationHeaderImageView.frame.size
                if destSize.width >= destSize.height {
                    circleView!.frame.size = CGSize(width: destSize.width, height: destSize.width)
                } else {
                    circleView!.frame.size = CGSize(width: destSize.height, height: destSize.height)
                }
                circleView!.layer.cornerRadius = circleView!.frame.size.width * 0.5
                circleView!.backgroundColor = modalVC.headerCircleColor()
                circleView!.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

                let circleSize = circleView!.frame.size
                circleView!.frame.origin = CGPoint(x: (destSize.width * 0.5) - (circleSize.width * 0.5), y: (destSize.height * 0.5) - (circleSize.height * 0.5))

                _destinationHeaderImageView.addSubview(circleView!)
            }

            containerView.addSubview(sourceImageView!)
            containerView.addSubview(destinationImageView!)
            destinationImageView?.isHidden = true

            rootVC.presentationBeforeAction()
            modalVC.presentationBeforeAction()

            modalVC.view.alpha = 0.0
        } else {
            sourceImageView = modalVC.createTransitionImageView()
            destinationImageView = rootVC.createTransitionImageView()
            sourceImageView!.layer.cornerRadius = destinationImageView!.layer.cornerRadius
            containerView.addSubview(sourceImageView!)

            rootVC.dismissalBeforeAction()
            modalVC.dismissalBeforeAction()

            sourceHeaderImageView = rootVC.createTransitionHeaderImageView()
            containerView.addSubview(sourceHeaderImageView!)
        }
    }

    func updateAnimation(_ transitionType: TransitionType, percentComplete: CGFloat) {
        if transitionType.isPresenting {
            sourceImageView?.frame = destinationImageView?.frame ?? CGRect.zero
            circleView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

            modalVC.view.alpha = 1.0

            rootVC.presentationAnimationAction(percentComplete)
            modalVC.presentationAnimationAction(percentComplete)
        } else {
            sourceImageView?.frame = destinationImageView?.frame ?? CGRect.zero

            if let _sourceHeaderImageView = sourceHeaderImageView {
                _sourceHeaderImageView.frame.origin.y -= _sourceHeaderImageView.frame.size.height
            }

            rootVC.dismissalAnimationAction(percentComplete)
            modalVC.dismissalAnimationAction(percentComplete)
        }
    }

    func finishAnimation(_ transitionType: TransitionType, didComplete: Bool) {
        if transitionType.isPresenting {
            sourceImageView?.removeFromSuperview()
            circleView?.removeFromSuperview()
            destinationHeaderImageView?.removeFromSuperview()

            rootVC.presentationCompletionAction(didComplete)
            modalVC.presentationCompletionAction(didComplete)
        } else {
            sourceImageView?.removeFromSuperview()
            sourceHeaderImageView?.removeFromSuperview()

            rootVC.dismissalCompletionAction(didComplete)
            modalVC.dismissalCompletionAction(didComplete)
        }
    }
}

extension GooglePlayTransitionAnimation {

    func sourceVC() -> UIViewController {
        if let nav = self.rootVC.navigationController {
            return nav
        }
        return self.rootVC
    }

    func destVC() -> UIViewController { return self.modalVC }
}
