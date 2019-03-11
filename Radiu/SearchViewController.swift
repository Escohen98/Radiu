//
//  SearchViewController.swift
//  Radiu
//
//  Created by Student User on 3/5/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Search: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! searchCell
        cell.name.text = "Default"
        cell.title.text = "This is a broadcast."
        cell.imageView?.image = UIImage(named: "hot_ico.png")
        return cell
    }
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self;
        tableView.dataSource = self;
        searchbar.barTintColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    /*
     * Downloads JSON file from given url and saves to UserDefaults
     * Copied from iQuiz project
     * Change to return a JSON object.
     * Should probably also move to another class/file
     * let savedJSON = UserDefaults.standard.string(forKey: "searchStreams")
     */
    func download(_ url: String, _ VC: UIViewController) {
        Alamofire.request(url).responseJSON{response in
            if response.result.value != nil {
                let data = JSON(response.result.value as Any)
                
                //We got the data, now we'll save the data in its state as a String
                UserDefaults.standard.set(data.rawString(), forKey: "searchStreams")
                //now that we saved we can parse this inforamtion into another function
                
            }
            else {
                let alert = UIAlertController(title: "Download Failed.", message: "Please try again later.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                VC.present(alert, animated: true, completion: nil)
                
            }
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

class searchCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
}
