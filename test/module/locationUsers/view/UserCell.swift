//
//  UserCell.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 14/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import UIKit
import Kingfisher

class UserCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setup(user: UserDTO) {
        if let avatar = user.avatar, let url = URL(string: avatar) {
            self.avatarImage.kf.setImage(with: url)
        }
        self.nameLabel.text = user.name
        self.timeLabel.text = user.timestamp?.format()
    }
    
    override func prepareForReuse() {
        self.avatarImage.image = nil
        self.nameLabel.text = ""
        self.timeLabel.text = ""
    }
}
