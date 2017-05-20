//
//  RootViewController.swift
//  mvvm-structure
//
//  Created by Hieu Huynh on 5/18/17.
//  Copyright © 2017 Fraternal Group Pte. Ltd. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    // IBActions
    @IBAction func buttonGetPostsPressed() {
        HHAPICaller.shared.getListUsers()
//        HHAPICaller.shared.getAllPosts().then { (listResponse) -> Void in
//            if let items = listResponse?.items {
//                print(items.count)
//            } else {
//                print("failed to map")
//            }
//        }.catch { (error) in
//            print("Failed to get posts: \(error)")
//        }
    }
}
