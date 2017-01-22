//
//  Transition.swift
//  Otadoya
//
//  Created by Dmitry Pilikov on 20/01/17.
//  Copyright © 2017 Dmitry Pilikov. All rights reserved.
//

import UIKit

class OpacityAnimation: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate{
    
    let duration = 0.3
   
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }

        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let container = transitionContext.containerView
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.alpha = 0

        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            
            fromView.alpha = 0.0
            toView.alpha = 1.0
        
        }) { (success) in
            transitionContext.completeTransition(success)
        }
        
        
    
    }
}
