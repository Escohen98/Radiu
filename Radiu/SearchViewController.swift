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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qcell", for: indexPath) as! searchCell
        cell.name.text = "Default"
        cell.title.text = "This is a broadcast."
        cell.imageView?.image = UIImage(named: "hot_ico.png")
        return cell
    }
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.barTintColor = UIColor.black
        // Do any additional setup after loading the view.
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
