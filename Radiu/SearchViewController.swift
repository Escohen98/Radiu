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
    let CHANNEL_URL = "https://audio-api.kjgoodwin.me/v1/channels"
    let SUB_URL = "https://audio-api.kjgoodwin.me/v1/channels/followed"
    //let CHANNEL_URL = "https://api.jsonbin.io/b/5c885df5bb08b22a75695907?fbclid=IwAR2oZzwfwP-k52AMSBKlrWEUBRy1Xdh83WlmXfoQL98umJ2-DDD1RhuAe_w";
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(data.arrayValue.count)
        if isFiltering() { //When the user is typing in the search bar
            if(selected == "user") {
                return filteredUserData.count
            }
            return filteredData.count
        } else if selected == "live" {
            return activeData.count
        } else if selected == "user" {
            return userData.count
        }
        return data.count //Also subscribed data
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
            print("data1: \(data1 as! channel)")
            cell.id = (data1 as! channel).id
            cell.active = (data1 as! channel).active
            print("cell.id \(cell.id)")
            //Fill label data
            //let data2 = data1 as! channel
            cell.displayName.text = (data1 as! channel).displayName //Main Label
            cell.title.text = "Awesome Stream!"//((data1 as! channel)).desc //Secondary Label
            cell.title.textColor = .black
            let newURL = URL(string: (data1 as! channel).creator["photoURL"].stringValue)
            let other = URL(string: "https://cdn2.iconfinder.com/data/icons/music-colored-outlined-pixel-perfect/64/music-35-512.png")
            let photoData = try? Data(contentsOf: newURL ?? other!)
            if let imageData = photoData {
                cell.profileImage.image = UIImage(data: imageData)
            } //Change later for creator object.
              cell.duration.text = Duration().formatDuration(cell: cell, createdAt: ((data1 as! channel)).createdAt)
            
        } else if selected == "user" {
            //Determines whether user has typed into search bar
            if isFiltering() {
                data1 = filteredUserData[indexPath.item]
            } else {
                data1 = userData[indexPath.item]
            }
            
            //Fill cell labels
            cell.displayName.text = (data1 as! user).userName //Main Label
            cell.id = String((data1 as! user).id)
            let stream = getUserChannel(creatorID: (data1 as! user).id)
            if(stream.active) {
                cell.title.text = "Live" //Secondary Label
                cell.title.textColor = UIColor(hue: 0.3917, saturation: 1, brightness: 0.69, alpha: 1.0)
            } else {
                cell.title.textColor = UIColor(hue: 0, saturation: 1, brightness: 0.93, alpha: 1.0)
                cell.title.text = "Offline."
            }
            //Fill Image
            let newURL = URL(string: (data1 as! user).photoURL)
            let other = URL(string: "https://cdn2.iconfinder.com/data/icons/music-colored-outlined-pixel-perfect/64/music-35-512.png")
            let photoData = try? Data(contentsOf: newURL ?? other!)
            if let imageData = photoData {
                cell.profileImage.image = UIImage(data: imageData)
            }
            
            //Fill stream duration if user is streaming
            cell.duration.text = ""
            if isLive(id: (data1 as! user).id) {
                cell.duration.text = Duration().formatDuration(cell: cell, createdAt: getUserChannel(creatorID: (data1 as! user).id).createdAt)
            }
        } else { //Same as live until subscribed is implemented.
            if isFiltering() {
                data1 = filteredData[indexPath.item]
            } else {
                data1 = data[indexPath.item]
            }
            cell.active = (data1 as! channel).active
            //let data2 = data1 as! channel
            cell.displayName.text = ((data1 as! channel)).displayName
            //Offline state.
            cell.title.text = "Offline."
            cell.title.textColor = UIColor(hue: 0, saturation: 1, brightness: 0.93, alpha: 1.0)
            let newURL = URL(string: (data1 as! channel).creator["photoURL"].stringValue)
            let other = URL(string: "https://cdn2.iconfinder.com/data/icons/music-colored-outlined-pixel-perfect/64/music-35-512.png")
            let photoData = try? Data(contentsOf: newURL ?? other!)
            if let imageData = photoData {
                cell.profileImage.image = UIImage(data: imageData)
            }
            
            //Sets cell duration only if active. Changes description to stream description and color back to dark gray.
            cell.duration.text = ""
            if(cell.active) {
                cell.duration.text = Duration().formatDuration(cell: cell, createdAt: ((data1 as! channel)).createdAt)
                 cell.title.text = (data1 as! channel).desc
                cell.title.textColor = .darkGray
            }
            cell.id = (data1 as! channel).id

            print("cell.id \(cell.id)")
            
        }
    }
    
    //Run when a cell is selected. Using for segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (cell as! searchCell).active && (selected == "live" || selected == "subscribed") {
            self.performSegue(withIdentifier: "streamSegue", sender: cell)
        } else {
            self.performSegue(withIdentifier: "profileSegue", sender: cell)
        }
    }
    
    //Probably don't need this
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "streamSegue" {
            /* Add Data to be segued to StreamVC here*/
            let streamVC = segue.destination as? StreamViewController
            /* Add Data to be segued to StreamVC here*/
            print("id")
            
            print("sender: \((sender as! searchCell).id)")
            streamVC?.streamID = (sender as! searchCell).id
        } else if segue.identifier == "profileSegue" {
            /* Add Data to be segued to ProfileVC here*/
            let profileVC = segue.destination as? ProfileViewController
            profileVC?.userData = getUser(creatorID: Int((sender as? searchCell)!.id) ?? -1)
            profileVC?.subscribedData = data
            if (sender as? searchCell)!.active {
                profileVC?.activeStream = getUserChannel(creatorID: Int((sender as? searchCell)!.id) ?? -1)
            }
        } else if segue.identifier == "userProfileSegue" {
            let profileVC = segue.destination as? ProfileViewController
            profileVC?.isActiveUser = true //Indicates that this is the logged in user.
            //profileVC?.userData = Figure out how to get logged-in user data.
            profileVC?.subscribedData = data
            /*
             Figure this out too
             if (sender as? searchCell)!.active {
             profileVC?.activeStream = getUserChannel(creatorID: Int((sender as? searchCell)!.id) ?? -1)
             }
             */
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    
    var selected = "live" //Selected tab
    
    //Handles tab bar selection changes
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        selected = item.title!.lowercased()
        //tableView.reloadData()
        //Refresh the data every time.
        if selected == "live" {
            download(CHANNEL_URL, self)
        } else if selected == "subscribed" {
            download(SUB_URL, self, true)
        } else {
            users().download(self, tableView, completion: { (userData: Array<user>) in
                self.userData = userData
                //print("userData: \(self.userData)")
                self.tableView.reloadData()
            }) //Safe-guard to prevent async problems.
        }
    }
    
    @IBOutlet weak var tabBar: UITabBar!
    
    let searchController = UISearchController(searchResultsController: nil)
    //Downloads JSON file, initializes tableView, then tries to set searchBar color to black
    override func viewDidLoad() {
        super.viewDidLoad()
        download(CHANNEL_URL, self)
        //download(SUB_URL, self, true)
        //users().download(self, tableView, completion: { (userData: Array<user>) in
        //    self.userData = userData
        //    print("userData: \(self.userData)")
        //    self.tableView.reloadData()
        //or}) //Safe-guard to prevent async problems.
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
    //var data: Array<channel> = []
    var data: Array<channel> = [] //Main array for JSON object
    var activeData: Array<channel> = [] //For active streams
    var userData: Array<user> = [] //For user list
    
    func download(_ url: String, _ VC: UIViewController, _ isSubscribed: Bool = false)  {
        if(!isSubscribed) {
        activeData = [] //Clears Arrays
        } else {
            data = [] // Also subscribed data
        }
        Repository.sessionManager.request(url).responseJSON{response in
            if response.result.value != nil {
                let data = JSON(response.result.value as Any)
                print("Data Length: \(data.count)")
                for d in data.arrayValue {
                    let newStruct = channel(id: d["channelID"].stringValue, desc: d["discription"].stringValue, genre: d["genre"].stringValue, createdAt: d["createdAt"].stringValue, creator: d["creator"], active: d["active"].boolValue, displayName: d["displayName"].stringValue, activeListeners: d["activeListeners"].arrayValue.map { $0.intValue}, followers: d["followers"].arrayValue.map { $0.intValue})
                    if !isSubscribed && newStruct.active {
                       self.activeData.append(newStruct)
                    } else {
                        self.data.append(newStruct)
                    }
                }
                self.tableView.reloadData()
                //print("Active data: \(self.activeData)")
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
    
    var filteredData: Array<channel> = []
    var filteredUserData: Array<user> = []
    //Determines what to filter
    //Currently using: displayName as filter.
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        if selected == "live" {
            filteredData = activeData.filter({( search : channel) -> Bool in
                return search.displayName.lowercased().contains(searchText.lowercased())
            })
        } else if selected == "subscribed" {
            filteredData = data.filter({( search : channel) -> Bool in
                return search.displayName.lowercased().contains(searchText.lowercased())
            })
        } else if selected == "user" {
            //Implementation Comes later
            //Temporary
            filteredUserData = userData.filter({( search : user) -> Bool in
                return search.userName.lowercased().contains(searchText.lowercased())
            })
        } else {
            filteredData = activeData.filter({( search : channel) -> Bool in
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
            if active.creator["id"].intValue == id {
                return true
            }
        }
        return false
    }
    
    //Returns the channel information for the given user. Makes sure the user isLive. Returns the channel object for the given user if Live, otherwise returns an empty object.
    func getUserChannel(creatorID: Int) -> channel {
        if(isLive(id: creatorID)) {
            for active in activeData {
                if active.creator["id"].intValue == creatorID {
                    return active
                }
            }
        }
        return channel()
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

struct channel {
    var id: String = ""
    var desc: String = ""
    var genre: String = ""
    var createdAt: String = ""
    var creator: JSON = []
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
    var id : String = ""
    var active = false
}
