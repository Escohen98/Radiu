//
//  ProfileViewController.swift
//  Radiu
//
//  Created by Student User on 3/15/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
  var isActiveUser: Bool = false //True if profile matches the logged in user; false otherwise.
  var userData: user = user() //The user's profile. Empty if isActiveUser is false.
  var activeStream: channel = channel() //Empty if given user is not streaming or if isActiveUser is false. Filled otherwise. Assumes user can only run 1 stream at a given time.
  
  @IBOutlet weak var photo: UIImageView!
  
  @IBOutlet weak var username: UILabel!
  
  @IBOutlet weak var stream_link: UIButton!
  
  @IBOutlet weak var live_icon: UIImageView!
  @IBOutlet weak var full_name: UILabel!
  
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
    print("browseVC?.selected: \(selected)")
    
    let default_image = URL(string: "https://cdn2.iconfinder.com/data/icons/music-colored-outlined-pixel-perfect/64/music-35-512.png")
    let photoData = try? Data(contentsOf: URL(string: userData.photoURL) ?? default_image!)
    if let imageData = photoData {
      photo.image = UIImage(data: imageData)
    }
    username.text = userData.userName
    full_name.text = "\(userData.firstName) \(userData.lastName)"
    if activeStream.active == true {
      stream_link.isHidden = false
      live_icon.isHidden = false
    }
  }
  
  @IBAction func goToLiveStream(_ sender: Any) {
    performSegue(withIdentifier: "profileToStream", sender: nil)
  }
  
  
  // MARK: - Navigation
  var selected = "" //Allows user to go back to tab they were on.
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "profileToBrowse":
      let browseVC = segue.destination as? Search
      browseVC?.selected = self.selected
      break
    case "profileToStream":
      let stream = segue.destination as? StreamViewController
      stream!.streamID = String(userData.id)
      break
    default:
      NSLog("No such segue identifier", segue.identifier ?? "<none>")
    }
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
  }
  
  
}
