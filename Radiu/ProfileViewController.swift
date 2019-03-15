//
//  ProfileViewController.swift
//  Radiu
//
//  Created by Student User on 3/15/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
     var userData: user = user() //The user's profile
    
    /*
     * Condition: current user profile
     *  List all channels user is subscribed to.
     * Condition: other user profile
     *  List any channels that other user owns that user is subscribed to.
     * Note: May not be necessary
    */
    var subscribedData: Array<channel> = [] //Channels user is subscribed to
    var activeStream: channel = channel() //Empty if given user is not streaming. Filled otherwise. Assumes user can only run 1 stream at a given time.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
