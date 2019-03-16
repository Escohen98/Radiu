//
//  ProfileViewController.swift
//  Radiu
//
//  Created by Student User on 3/15/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var isActiveUser: Bool = false //True if profile matches the logged in user; false otherwise.
    var userData: user = user() //The user's profile. Empty if isActiveUser is false.
    var activeStream: channel = channel() //Empty if given user is not streaming or if isActiveUser is false. Filled otherwise. Assumes user can only run 1 stream at a given time.
    
    /*
     * Condition: current user profile
     *  List all channels user is subscribed to.
     * Condition: other user profile
     *  List any channels that other user owns that user is subscribed to.
     * Note: May not be necessary
    */
    var subscribedData: Array<channel> = [] //Channels user is subscribed to
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isActiveUser {
            //Pull user data from API
            //Intialize userData and activeStream
            //May need some helper functions from StreamViewController (isLive, getUser, and getUserChannel. Maybe make a protocol or new class?)
        }
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
