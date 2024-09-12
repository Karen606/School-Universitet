//
//  TodayEventPresentationController.swift
//  Universitet
//
//  Created by Karen Khachatryan on 11.09.24.
//

import UIKit

protocol TodayPresentationControllerDelegate: AnyObject {
    func dismissController()
}

class TodayEventPresentationController: UIPresentationController {
    var presentationDelegate: TodayPresentationControllerDelegate?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero}
        if let presentedViewController = presentedViewController as? DayInfoViewController {
            return CGRect(origin: CGPoint(x: 0, y: containerView.frame.height * 0.5),
                          size: CGSize(width: containerView.frame.width, height: containerView.frame.height *
                           0.5))
        }
        guard let presentedViewController = presentedViewController as? CreateClassViewController else { return .zero }
        
        let targetSize = CGSize(width: containerView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let fittingHeight = presentedViewController.contentView.systemLayoutSizeFitting(targetSize).height + 24
                
        if fittingHeight <= (containerView.bounds.height) * 0.9 {
            return CGRect(x: 0, y: containerView.bounds.height - fittingHeight, width: containerView.bounds.width, height: fittingHeight)
        } else { 
            return CGRect(origin: CGPoint(x: 0, y: containerView.frame.height * 0.1),
                          size: CGSize(width: containerView.frame.width, height: containerView.frame.height *
                           0.9))
        }
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
           guard let presentedViewController = presentedViewController as? UIViewController else { return }
           presentedView?.frame = frameOfPresentedViewInContainerView
       }

    override func presentationTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
      presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    @objc func dismissController(){
        presentationDelegate?.dismissController()
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
