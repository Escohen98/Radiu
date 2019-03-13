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

class users: NSObject {
    /*
     * Downloads JSON file from given url and saves to UserDefaults
     * Copied from iQuiz project
     * Change to return a JSON object.
     * Should probably also move to another class/file
     * let savedJSON = UserDefaults.standard.string(forKey: "searchStreams")
     */
     let USER_URL = "https://api.jsonbin.io/b/5c86bfb88545b0611997cabd"
    func download(_ VC: UIViewController, _ tableView: UITableView, completion: @escaping (Array<user>) -> Void) {
        var returnData: Array<user> = []
        Alamofire.request(USER_URL).responseJSON{response in
            if response.result.value != nil {
                let data = JSON(response.result.value as Any)
                print("Data: \(data)")
                    let newStruct = user(id: data["id"].intValue, photoURL: data["photoURL"].stringValue, firstName: data["firstName"].stringValue, lastName: data["lastName"].stringValue, userName: data["userName"].stringValue)
                    returnData.append(newStruct)
                print(returnData)
                completion(returnData)
                //tableView.reloadData()
                return
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
        
    }
}

struct user {
    var id: Int = -1
    var photoURL: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var userName: String = ""
}
