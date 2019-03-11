//
//  BrowseViewController.swift
//  Radiu
//
//  Created by Admin on 3/5/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BrowseViewController: UITableViewController {
  
  @IBOutlet weak var stream_list: UITableView!
  
  // TODO: This is dummy data
  let streams : [Stream] = [Stream("My Podcast", "user123", 1280), Stream("My Radio", "test123", 240), Stream("My Music", "somebody123", 2009)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    stream_list.dataSource = self
    stream_list.delegate = self
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  // MARK: - Table view data source
  
  //    override func numberOfSections(in tableView: UITableView) -> Int {
  //        // #warning Incomplete implementation, return the number of sections
  //        return 0
  //    }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return streams.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = stream_list.dequeueReusableCell(withIdentifier: "StreamItem", for: indexPath) as! StreamCell
    
    let current_stream : Stream = streams[indexPath.item]
    cell.title.text = current_stream.title
    cell.username.text = current_stream.user
    
    let seconds = current_stream.current_duration % 60
    let minutes = current_stream.current_duration / 60
    let hours = minutes / 60
    
    var duration = "\(String(seconds))"
    if(seconds < 10) {
      duration = "0\(duration)"
    }
    if(minutes > 0) {
      duration = "\(String(minutes)):\(duration)"
      if(hours > 0) {
        duration = "\(String(hours)):\(duration)"
      }
    }
    
    print(duration);
    
    cell.current_duration.text = duration
    
    Alamofire.request(current_stream.image_url).responseImage {
      response in
      if let result = response.result.value {
        cell.image_icon.image = result
      }
    }
    
    return cell
  }
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

class StreamCell : UITableViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var current_duration: UILabel!
  @IBOutlet weak var image_icon: UIImageView!
}

class Stream {
  var title : String = ""
  var user : String = ""
  var current_duration : Int = 0
  
  // TODO: This is a placeholder image
  var image_url : String = "https://unixtitan.net/images/waveform-vector-6.png"
  
  init(_ title : String, _ user : String, _ current_duration: Int) {
    self.title = title
    self.user = user
    self.current_duration = current_duration

    // self.image_url = image_url
  }
}
