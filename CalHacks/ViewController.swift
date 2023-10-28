//
//  ViewController.swift
//  CalHacks
//
//  Created by Andrew Zheng on 10/28/23.
//

import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        addChildViewController(hostingController, in: view)
        
        print("Added!")
        
    }


}

