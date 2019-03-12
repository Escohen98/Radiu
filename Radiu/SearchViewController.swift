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

class Search: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    let CHANNEL_URL = "https://audio-api.kjgoodwin.me/v1/audio/channels/all"
    let USER_URL = "https://api.jsonbin.io/b/5c86bfb88545b0611997cabd?fbclid=IwAR2NQM0G1nDZ2P-nd4OQOi-M-UC20mN2OQ69EJJqrnBvwrrAgESaBBmZRoE"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(data.arrayValue.count)
        if isFiltering() {
            return filteredData.count
        } else if isActiveTab() {
            return activeData.count
        }
        return data.count
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }

    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! searchCell
        
        let data1 : searchProperties
        if isFiltering() {
            data1 = filteredData[indexPath.item]
        } else if isActiveTab() {
            data1 = activeData[indexPath.item]
        } else {
            data1 = data[indexPath.item]
        }
        //TODO - Filter out non-active streams when Live tabbar is selected
        
        
        cell.displayName.text = data1.displayName
        cell.title.text = data1.desc
        cell.profileImage.image = UIImage(named: "hot_ico.png")
        return cell
    }
    
    @IBOutlet weak var tabBar: UITabBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    //Downloads JSON file, initializes tableView, then tries to set searchBar color to black
    override func viewDidLoad() {
        super.viewDidLoad()
        download(CHANNEL_URL, self)
        
        tabBar.selectedItem = tabBar.items![0]
        
        //Search taken from https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
        // Setup the Search Controller
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.barTintColor = .black
        navigationItem.searchController = searchController
        self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self
        //searchbar.barTintColor = UIColor.black
       
    }
    
    /*
     * Downloads JSON file from given url and saves to UserDefaults
     * Copied from iQuiz project
     * Change to return a JSON object.
     * Should probably also move to another class/file
     * let savedJSON = UserDefaults.standard.string(forKey: "searchStreams")
     */
    //var data: Array<searchProperties> = []
    var data: Array<searchProperties> = [] //Main array for JSON object
    var activeData: Array<searchProperties> = [] //For active streams
    func download(_ url: String, _ VC: UIViewController)  {
        Alamofire.request(url).responseJSON{response in
            if response.result.value != nil {
                let data = JSON(response.result.value as Any)
                for d in data.arrayValue {
                    let newStruct = searchProperties(id: d["id"].stringValue, desc: d["discription"].stringValue, genre: d["genre"].stringValue, createdAt: d["createdAt"].stringValue, creator: d["creator"].intValue, active: d["active"].boolValue, displayName: d["displayName"].stringValue)
                    self.data.append(newStruct)
                    if newStruct.active {
                       self.activeData.append(newStruct)
                    }
                }
                self.tableView.reloadData()
                print("Active data: \(self.activeData)")
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
    
    //Taken from https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
    // MARK: - Private instance methods

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var filteredData: Array<searchProperties> = []
    //Determines what to filter
    //Currently using: displayName as filter.
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if isActiveTab() {
            filteredData = data.filter({( search : searchProperties) -> Bool in
                return search.displayName.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredData = activeData.filter({( search : searchProperties) -> Bool in
                return search.displayName.lowercased().contains(searchText.lowercased())
            })
        }
        
        tableView.reloadData()
    }
    
    //Checks if user is searching for something specific
    //Returns true if user has typed into search bar. False otherwise.
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func isActiveTab() -> Bool {
        return tabBar.selectedItem! == tabBar.items![0]
    }
}

//Taken from https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
extension Search: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

struct searchProperties {
    var id: String = ""
    var desc: String = ""
    var genre: String = ""
    var createdAt: String = ""
    var creator: Int = 0
    var active: Bool = false
    var displayName: String = ""
}

class searchCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var title: UILabel!
}
