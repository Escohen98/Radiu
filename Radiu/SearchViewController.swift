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
    //let CHANNEL_URL = "https://audio-api.kjgoodwin.me/v1/audio/channels/all"
    let CHANNEL_URL = "https://api.jsonbin.io/b/5c885df5bb08b22a75695907?fbclid=IwAR2oZzwfwP-k52AMSBKlrWEUBRy1Xdh83WlmXfoQL98umJ2-DDD1RhuAe_w";
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(data.arrayValue.count)
        if isFiltering() { //When the user is typing in the search bar
            return filteredData.count
        } else if selected == "live" {
            return activeData.count
        } else if selected == "subscribed" {
            //Implementation comes later
        } else if selected == "user" {
            return userData.count
        }
        return data.count
    }

    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! searchCell
        
        initCell(cell: cell, indexPath: indexPath)
        //TODO - Filter out non-active streams when Live tabbar is selected
        
        
        
        return cell
    }
    
    
    //Specifies which tab is selected and assigns data/initializes cell accordingly.
    func initCell(cell: searchCell, indexPath: IndexPath) {
        let data1: Any
        if selected == "live" {
            if isFiltering() {
                data1 = filteredData[indexPath.item]
            } else {
                data1 = activeData[indexPath.item]
            }
            
            cell.displayName.text = (data1 as! searchProperties).displayName
            cell.title.text = "Awesome Stream!"//(data1 as! searchProperties).desc
            cell.profileImage.image = UIImage(named: "hot_ico")
              cell.duration.text = Duration().formatDuration(cell: cell, createdAt: (data1 as! searchProperties).createdAt)
            
        } else if selected == "user" {
            if isFiltering() {
                data1 = filteredData[indexPath.item]
            } else {
                data1 = userData[indexPath.item]
            }
            
            cell.displayName.text = (data1 as! user).userName
            cell.title.text = "Offline."
            let newURL = URL(string: (data1 as! user).photoURL)
            let other = URL(string: "https://cdn2.iconfinder.com/data/icons/music-colored-outlined-pixel-perfect/64/music-35-512.png")
            let photoData = try? Data(contentsOf: newURL ?? other!)
            if let imageData = photoData {
                cell.profileImage.image = UIImage(data: imageData)
            }
            
            cell.duration.text = ""
            if isLive(id: (data1 as! user).id) {
                cell.duration.text = Duration().formatDuration(cell: cell, createdAt: (data1 as! searchProperties).createdAt)
            }
        } else { //Same as live until subscribed is implemented.
            if isFiltering() {
                data1 = filteredData[indexPath.item]
            } else {
                data1 = data[indexPath.item]
            }
            
            cell.displayName.text = (data1 as! searchProperties).displayName
            cell.title.text = "Awesome Stream!"//(data1 as! searchProperties).desc
            cell.profileImage.image = UIImage(named: "hot_ico")
            cell.duration.text = Duration().formatDuration(cell: cell, createdAt: (data1 as! searchProperties).createdAt)
            
        }
    }
    
    //Run when a cell is selected. Using for segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selected == "live" {
            //let streamVC = StreamViewController();
            //self.present(streamVC, animated: true, completion: nil)
        } else if selected == "subscribed" {
            //let streamVC = StreamViewController();
            //self.present(streamVC, animated: true, completion: nil)
        } else {
            //let profileVC = ProfileViewController();
            //self.present(profileVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selected == "live" {
            /* Add Data to be segued to StreamVC here*/
        } else if selected == "subscribed" {
            /* Add Data to be segued to StreamVC here*/
        } else {
            /* Add Data to be segued to ProfileVC here*/
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    
    var selected = "live" //Selected tab
    
    //Handles tab bar selection changes
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        selected = item.title!.lowercased()
        tableView.reloadData()
    }
    
    @IBOutlet weak var tabBar: UITabBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    //Downloads JSON file, initializes tableView, then tries to set searchBar color to black
    override func viewDidLoad() {
        super.viewDidLoad()
        download(CHANNEL_URL, self)
        users().download(self, tableView, completion: { (userData: Array<user>) in
            self.userData = userData
            print("userData: \(self.userData)")
            self.tableView.reloadData()
        }) //Safe-guard to prevent async problems.
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
    var userData: Array<user> = [] //For user list
    
    func download(_ url: String, _ VC: UIViewController)  {
        Repository.sessionManager.request(url).responseJSON{response in
            if response.result.value != nil {
                let data = JSON(response.result.value as Any)
                for d in data.arrayValue {
                    let newStruct = searchProperties(id: d["id"].stringValue, desc: d["discription"].stringValue, genre: d["genre"].stringValue, createdAt: d["createdAt"].stringValue, creator: d["creator"].intValue, active: d["active"].boolValue, displayName: d["displayName"].stringValue, activeListeners: d["activeListeners"].arrayValue.map { $0.intValue}, followers: d["followers"].arrayValue.map { $0.intValue})
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
        if selected == "live" {
            filteredData = data.filter({( search : searchProperties) -> Bool in
                return search.displayName.lowercased().contains(searchText.lowercased())
            })
        } else if selected == "subscribed" {
            //Implementation Comes later
            //Temporary
            filteredData = data.filter({( search : searchProperties) -> Bool in
                return search.displayName.lowercased().contains(searchText.lowercased())
            })
        } else if selected == "users" {
            //Implementation Comes later
            //Temporary
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
    
    //Checks if given user is currently streaming. Returns true if yes, false otherwise.
    func isLive(id: Int) -> Bool {
        for active in activeData {
            if active.creator == id {
                return true
            }
        }
        return false
    }
    
    //Returns the channel information for the given user. Makes sure the user isLive. Returns the searchProperties object for the given user if Live, otherwise returns an empty object.
    func getUserChannel(creatorID: Int) -> searchProperties {
        if(isLive(id: creatorID)) {
            for active in activeData {
                if active.creator == creatorID {
                    return active
                }
            }
        }
        return searchProperties()
    }
    
    //Returns user information for given id. Since all active users are part of users, should return a filled user every time. If live user is somehow not in userData, returns empty user object.
    func getUser(creatorID: Int) -> user {
        for uD in userData {
            if(creatorID == uD.id) {
                return uD
            }
        }
        return user()
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
    var activeListeners: [Int] = []
    var followers: [Int] = []
    
}

class searchCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var duration: UILabel!
    
}
