//
//  BrowseViewController.swift
//  Radiu
//
//  Created by Admin on 3/5/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

let STREAM_LIST_URL : String = "https://audio-api.kjgoodwin.me/v1/audio/channels/all"
let USER_LIST_URL : String = "https://api.jsonbin.io/b/5c86bfb88545b0611997cabd"

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class BrowseViewController: UITableViewController {
  
  @IBOutlet weak var stream_list: UITableView!
  
  // TODO: This is dummy data
  var streams : [Stream] = [Stream("My Podcast", "user123", 1280), Stream("My Radio", "test123", 240), Stream("My Music", "somebody123", 2009)]
//  var streams : [Stream] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.stream_list.dataSource = self
    self.stream_list.delegate = self

    Alamofire.request(STREAM_LIST_URL).responseJSON {
      response in
      if let result = response.result.value {
        let json = JSON(result)
        for stream_data in json.arrayValue {
          let stream = self.parseStreamList(stream_data)
          print("testing")
          self.streams.append(stream)
        }
        self.stream_list.reloadData()
      }
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  func parseStreamList(_ stream : JSON) -> Stream {
    let name = stream["displayName"].stringValue
    let user = stream["creator"].stringValue
    
    let current_date = Date()
    let isoDate = stream["goLiveTime"].stringValue
    var current_duration = 0
    
    if stream["goLiveTime"].exists() {
      let calendar = Calendar.current

      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
      let start_date = dateFormatter.date(from:isoDate)!

      current_duration = Int(calendar.component(.second, from: current_date)) - Int(calendar.component(.second, from: start_date))
    }
    
    let new_stream : Stream = Stream(name, user, current_duration)
    return new_stream
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    print("size", streams.count)
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
  var image_url : String = ""
  
  init(_ title : String, _ user : String, _ current_duration: Int) {
    self.title = title
    self.user = user
    self.current_duration = current_duration
  }
}
