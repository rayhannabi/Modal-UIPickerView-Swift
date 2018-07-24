//
//  RNTransitionController.swift
//  CustomTransitionDemo2
//
//  Created by Rayhan Janam on 6/17/18.
//  Copyright © 2018 Rayhan Janam. All rights reserved.
//

import UIKit

/// Type of transitions available when a view controller
/// is presented modally
///
/// - coverVertical: Provides default cover transition sliding from the bottom
/// - coverHorizontal: Provides cover transition sliding from the left
/// - fadeIn: Provides a fade-in transition
/// - fadeInWithSubviewZoomIn: Provides a fade-in transition with a zoom-in animation for the subview
/// - slideIn: Provides a slide-in transition
enum RNTransitionAnimation {
    case coverVertical
    case coverHorizontal
    case fadeIn
    case fadeInWithSubviewZoomIn
    case slideIn
}


/// Default transition duration of 0.25 seconds
let RNTransitionAnimationDuration: TimeInterval = 0.25


/// Provides custom View Controller transitions methods
class RNTransitionController: NSObject {
    
    private(set) var duration: TimeInterval
    private(set) var subviewTag: Int
    
    var isPresenting: Bool!
    var animation: RNTransitionAnimation!
    
    override init() {
        duration = RNTransitionAnimationDuration
        subviewTag = -1
    }
    
    /// Presents a view controller with specified transition animation
    ///
    /// - Parameters:
    ///   - presentedViewController: View controller which is to be presented
    ///   - presentingViewController: View controller which is presenting the modal view controller
    ///   - animation: Transition animation option
    public func present(viewController presentedViewController: UIViewController, from presentingViewController: UIViewController, animation: RNTransitionAnimation) {
        
        self.animation = animation
        
        presentedViewController.view.isOpaque = false
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.transitioningDelegate = self
        presentedViewController.modalPresentationCapturesStatusBarAppearance = true
        presentedViewController.setNeedsStatusBarAppearanceUpdate()
        
        presentingViewController.present(presentedViewController, animated: true, completion: nil)
    }
    
    /// Presents a view controller with specified transition animation
    ///
    /// - Parameters:
    ///   - presentedViewController: View controller which is to be presented
    ///   - presentingViewController: View controller which is presenting the modal view controller
    ///   - animation: Transition animation option
    ///   - duration: Duration of the transition animation
    public func present(viewController presentedViewController: UIViewController, from presentingViewController: UIViewController, animation: RNTransitionAnimation, duration: TimeInterval) {
        
        self.duration = duration
        
        self.present(viewController: presentedViewController, from: presentingViewController, animation: animation)
        
    }
    
    /// Presents a view controller with specified transition animation
    ///
    /// - Parameters:
    ///   - presentedViewController: View controller which is to be presented
    ///   - presentingViewController: View controller which is presenting the modal view controller
    ///   - animation: Transition animation option
    ///   - duration: Duration of the transition animation
    ///   - subviewTag: The tag value associated with the view which to be animated with fadeInWithSubviewZoomIn animation option
    public func present(viewController presentedViewController: UIViewController, from presentingViewController: UIViewController, animation: RNTransitionAnimation, duration: TimeInterval, subviewTag: Int) {
        
        self.duration = duration
        self.subviewTag = subviewTag

        self.present(viewController: presentedViewController, from: presentingViewController, animation: animation)
        
    }
    
}

// MARK: - UIViewControllerTransitionDelegate Methods

extension RNTransitionController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresenting = true
        return self
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresenting = false
        return self
        
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning delegate methods

extension RNTransitionController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let firstVC = transitionContext.viewController(forKey: .from)
        let secondVC = transitionContext.viewController(forKey: .to)
        
        if firstVC != nil, secondVC != nil {
            let containerView = transitionContext.containerView
            let firstView = firstVC!.view!
            let secondView = secondVC!.view!
            
            switch (self.animation!) {
                
            case .coverVertical:
                self.coverVerticalAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView)
                
            case .coverHorizontal:
                self.coverHorizontalAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView)
                
            case .fadeIn:
                self.fadeInAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView)
                
            case .fadeInWithSubviewZoomIn:
                self.fadeInSubviewZoomInAnimation(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView, subviewTag: subviewTag)
                
            case .slideIn:
                self.slideInAniamtion(with: transitionContext, containerView: containerView, firstView: firstView, secondView: secondView)
            }
        }
        
    }
    
}

// MARK: - Animation Methods

extension RNTransitionController {
    
    func coverVerticalAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView) {
        
        let originX = containerView.frame.origin.x
        let originY = containerView.frame.origin.y + containerView.frame.size.height
        let width = containerView.frame.size.width
        let height = containerView.frame.size.height
        
        if isPresenting {
            
            containerView.addSubview(secondView)
            secondView.alpha = 1.0
            secondView.frame = CGRect(x: originX, y: originY, width: width, height: height)
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                secondView.frame = containerView.frame
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        } else {
            
            UIView.animate(withDuration: self.duration, animations: {
                firstView.frame = CGRect(x: originX, y: originY, width: width, height: height)
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
        
    }
    
    func coverHorizontalAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView) {
        
        let originX = containerView.frame.origin.x + containerView.frame.size.width
        let originY = containerView.frame.origin.y
        let width = containerView.frame.size.width
        let height = containerView.frame.size.height
        
        if isPresenting {
            
            containerView.addSubview(secondView)
            secondView.alpha = 1.0
            secondView.frame = CGRect(x: originX, y: originY, width: width, height: height)
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                secondView.frame = containerView.frame
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        } else {
            
            UIView.animate(withDuration: self.duration, animations: {
                firstView.frame = CGRect(x: originX, y: originY, width: width, height: height)
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
        
    }
    
    func fadeInAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView) {
        
        if isPresenting {
            containerView.addSubview(secondView)
            secondView.alpha = 0.0
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                secondView.alpha = 1.0
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        } else {
            UIView.animate(withDuration: self.duration, animations: {
                firstView.alpha = 0.0
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
        
    }
    
    func fadeInSubviewZoomInAnimation(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView, subviewTag: Int) {
        
        if isPresenting {
            containerView.addSubview(secondView)
            secondView.alpha = 0.0
            
            let thirdView = secondView.viewWithTag(subviewTag)
            
            if thirdView != nil {
                thirdView!.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveEaseOut, animations: {
                secondView.alpha = 1.0
                if thirdView != nil {
                    thirdView!.transform = CGAffineTransform.identity
                }
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
            
        } else {
            UIView.animate(withDuration: self.duration, animations: {
                firstView.alpha = 0.0
            }) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
        
    }
    
    func slideInAniamtion(with transitionContext: UIViewControllerContextTransitioning, containerView: UIView, firstView: UIView, secondView: UIView) {
        
        let originX = containerView.frame.origin.x + containerView.frame.size.width
        let originY = containerView.frame.origin.y
        let width = containerView.frame.size.width
        let height = containerView.frame.size.height
        
        if isPresenting {
            
            containerView.addSubview(secondView)
            
            firstView.frame = containerView.frame
            secondView.frame = CGRect(x: originX, y: originY, width: width, height: height)
            
            let newOriginX = containerView.frame.origin.x - containerView.frame.size.width
            
            UIView.animate(withDuration: duration, animations: {
                
                firstView.frame = CGRect(x: newOriginX, y: originY, width: width, height: height)
                secondView.frame = containerView.frame
                
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
            
        } else {
            
            UIView.animate(withDuration: duration, animations: {
                
                firstView.frame = CGRect(x: originX, y: originY, width: width, height: height)
                secondView.frame = containerView.frame
                
            }) { (completed) in
                transitionContext.completeTransition(completed)
            }
            
        }
        
    }
    
}













































