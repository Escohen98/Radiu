//
//  ViewController.swift
//  Radiu
//
//  Created by Student User on 3/5/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Auto-segue to next view.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "goToMainUI", sender: self)
    }


}

