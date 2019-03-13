//
//  CommentTVCell.swift
//  Radiu
//
//  Created by Conor Reiland on 3/7/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import Foundation
import UIKit

class CommentTVCell: UITableViewCell{
    
    var comment: Comment?
    
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentUserPhoto: UIImageView!
    @IBOutlet weak var commentUsername: UILabel!
    
    func setComment(comment: Comment){
        self.comment = comment
        commentText.text = comment.text;
        commentUserPhoto = comment.userPhoto;
        commentUsername.text = comment.username
    }
}
