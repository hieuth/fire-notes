//
//  LoadingView.swift
//  AskNTeach
//
//  Created by Hieu Huynh on 4/26/16.
//  Copyright © 2016 Kins Solutions. All rights reserved.
//

import UIKit


class LoadingView: UIView {
    static weak var _activityView:LoadingView? = nil
    static var count = 0

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var whiteRoundedView: UIView!
    
    // show an activity view
    static func show() {
        self.show(nil)
    }
    static func show(_ title: String?) {
        //TODO: Uncomment
        //guard appDelegate.networkReachability.isReachable() else {return}
        // alloc a view if it hasn't existed
        if _activityView == nil {
            let activityView = LoadingView.view(withNibName: LoadingView.name()) as LoadingView
            activityView.alpha = 0
            activityView.translatesAutoresizingMaskIntoConstraints = false
            // add view to window
            if let window = UIApplication.shared.keyWindow {
                activityView.frame = window.bounds
                window.addSubview(activityView)
                UIView.animate(withDuration: 0.2, animations: {
                    activityView.alpha = 1.0
                })
                
                // autolayout
                let views = ["view" : activityView]
                let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: views)
                let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: views)
                window.setNeedsUpdateConstraints()
                window.addConstraints(verticalConstraints)
                window.addConstraints(horizontalConstraints)
            }
            _activityView = activityView
        }
        if let labelText = title {
            _activityView?.label.text = labelText
        } else {
            _activityView?.label.text = "Loading..."
        }
        let window = UIApplication.shared.keyWindow!
        window.bringSubview(toFront: _activityView!)
        // show the activity indicator
        count += 1
        _activityView?.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            _activityView?.alpha = 1.0
        })
    }
    
    // hide activity view
    static func hide() {
        count -= 1
        if count <= 0 {
            count = 0
            UIView.animate(withDuration: 0.2, animations: {
                _activityView?.alpha = 0
                }, completion: { (finished) in
                _activityView?.isHidden = true
            })
        }
    }
}
