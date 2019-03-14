//
//  Comment.swift
//  Radiu
//
//  Created by Conor Reiland on 3/11/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import Foundation
import UIKit

class Comment: NSObject {
    var text: String
    var userPhoto: URL
    var username: String
    
    /*
    private enum CodingKeys: String, CodingKey{
        case text
    }
    
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(String.self, forKey: .text)
    }*/
    
    init(text: String, image: URL, username: String){
        self.text = text
        self.userPhoto = image
        self.username = username
    }
    
}
