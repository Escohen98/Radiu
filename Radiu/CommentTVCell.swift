//
//  CommentTVCell.swift
//  Radiu
//
//  Created by Conor Reiland on 3/7/19.
//  Copyright © 2019 University of Washington. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class CommentTVCell: UITableViewCell{
    
    var comment: Comment?
    
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentUserPhoto: UIImageView!
    @IBOutlet weak var commentUsername: UILabel!
    
    func setComment(comment: Comment){
        self.comment = comment
        commentText.text = comment.text;
        commentUserPhoto.kf.setImage(with: comment.userPhoto)
        commentUsername.text = comment.username
    }
}
