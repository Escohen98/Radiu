//
//  download.swift
//  Radiu
//
//  Created by Student User on 3/11/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class download: NSObject {
    /*
     * Downloads JSON file from given url and saves to UserDefaults
     * Copied from iQuiz project
     * Change to return a JSON object.
     * Should probably also move to another class/file
     * let savedJSON = UserDefaults.standard.string(forKey: "searchStreams")
     */
    func download(_ url: String, _ VC: UIViewController, _ tableView: UITableView) -> Array<searchProperties> {
        var returnData: Array<searchProperties> = []
        Alamofire.request(url).responseJSON{response in
            if response.result.value != nil {
                let data = JSON(response.result.value as Any)
                for d in data.arrayValue {
                    let newStruct = searchProperties(id: d["id"].stringValue, desc: d["discription"].stringValue, genre: d["genre"].stringValue, createdAt: d["createdAt"].stringValue, creator: d["creator"].intValue, active: d["active"].boolValue, displayName: d["displayName"].stringValue)
                    returnData.append(newStruct)
                }
                tableView.reloadData()
                
                //We got the data, now we'll save the data in its state as a String
                //UserDefaults.standard.set(data.rawString(), forKey: "searchStreams")
                //now that we saved we can parse this inforamtion into another function
            }
            else {
                let alert = UIAlertController(title: "Download Failed.", message: "Please try again later.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                VC.present(alert, animated: true, completion: nil)
                
            }
        }
        return returnData
    }
}
