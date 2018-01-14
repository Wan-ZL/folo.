//
//  SearchSplitViewController.swift
//  Classroom Locator
//
//  Created by Wenkang Zhou on 2018/1/13.
//  Copyright © 2018年 Wenkang Zhou. All rights reserved.
//

import UIKit

class SearchSplitViewController : UISplitViewController, UISplitViewControllerDelegate {
    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        // return true to prevent UIKit from applying its default behavior
        return true
    }
}
