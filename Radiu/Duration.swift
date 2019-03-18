//
//  Duration.swift
//  Radiu
//
//  Created by Student User on 3/14/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit
import SwiftyJSON

class Duration: NSObject {
    //Pulls streamlist information
    //UserID, ImageURL
    //Creates object then handles all durations
    //Converts into seconds
   /* func parseStreamList(_ stream : searchProperties) -> Stream {
        let name = stream["displayName"].stringValue
        let user = stream["creator"].stringValue
        
        let image_url = stream["image"].stringValue
        
        let new_stream : Stream = Stream(name, user, 0, image_url)
        new_stream.current_duration = self.getDurationInSeconds(stream: stream)
        print(new_stream.current_duration)
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            new_stream.current_duration += 1
            print("\(new_stream.title): \(new_stream.current_duration)")
            self.stream_list.reloadData()
        })
        return new_stream
    }*/
    
    //Gets the current duration in seconds
    func getDurationInSeconds(isoDate : String) -> Int {
            let current_date = Date()
            let calendar = Calendar.current
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            let start_date = dateFormatter.date(from:isoDate)!
            
            let current_duration = (Int(calendar.component(.day, from: current_date) * 60 * 3600) - Int(calendar.component(.day, from: start_date)) * 60 * 3600) + (Int(calendar.component(.hour, from: current_date) * 3600) - Int(calendar.component(.hour, from: start_date)) * 3600) + (Int(calendar.component(.minute, from: current_date) * 60) - Int(calendar.component(.minute, from: start_date)) * 60) + (Int(calendar.component(.second, from: current_date)) - Int(calendar.component(.second, from: start_date)))
            print(current_duration)
            return current_duration
    }
    
    func formatDuration(cell: searchCell, createdAt: String) -> String {
        let current_duration = getDurationInSeconds(isoDate: createdAt)
        let hours = current_duration / 3600
        let minutes = (current_duration - (hours * 3600)) / 60
        let seconds = (current_duration - (hours * 3600) - (minutes * 60))
        
        var duration = "\(String(seconds))"
        if(seconds < 10) {
          duration = "0\(duration)"
          if current_duration < 60 {
            duration = "0:\(duration)"
          }
        }
        if(minutes > 0) {
            if(minutes < 10) {
              duration = "0\(String(minutes)):\(duration)"
            } else {
              duration = "\(String(minutes)):\(duration)"
            }
            if(hours > 0) {
              if hours < 10 {
                duration = "0\(String(hours)):\(duration)"
              } else {
                duration = "\(String(hours)):\(duration)"
              }
              
            }
        }
      
        print(duration)
        return duration
    }
}
