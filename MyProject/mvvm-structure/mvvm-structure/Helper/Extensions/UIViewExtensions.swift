//
//  UIViewExtensions.swift
//
//  Created by Hieu Huynh on 2/14/17.
//  Copyright © 2017 Kins Solutions. All rights reserved.
//

import UIKit

extension UIView {
    // load view from nib
    class func view<T:UIView>(withNibName nibName:String?, owner:AnyObject? = nil) -> T {
        // nib name
        let name = nibName ?? self.name()
        // load view from nib
        return Bundle.main.loadNibNamed(name, owner: owner, options: nil)!.first as! T
    }
    func addFullSizeSubview(_ view:UIView, animate: Bool = false, completion:((Bool)->Void)? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = animate ? 0.0 : 1.0
        self.addSubview(view)
        let views = ["view" : view]
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: views))
        self.setNeedsUpdateConstraints()
        self.addConstraints(constraints)
        if animate {
            UIView.animate(withDuration: 0.4, animations: {
                view.alpha = 1.0
            }, completion: completion)
        }
        }
    
    
    
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func rawCircle(radius:CGFloat, borderWidth:CGFloat = 1.0, borderColor:UIColor = UIColor.clear) {
        self.layer.borderColor      = borderColor.cgColor
        self.layer.borderWidth      = borderWidth
        self.layer.cornerRadius     = radius
        self.layer.masksToBounds    = true
    }

    func applyRoundedCorner(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyRoundedCorner() {
        applyRoundedCorner(radius: self.frame.height/2)
    }
    
    func applyBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
        
    func addBlurEffect() {
        var darkBlur:UIBlurEffect = UIBlurEffect()
        if #available(iOS 10.0, *) { //iOS 10.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)//prominent,regular,extraLight, light, dark
        } else { //iOS 8.0 and above
            darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light) //extraLight, light, dark
        }
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.frame //your view that have any objects
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurView, at: 0)
    }
    
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

