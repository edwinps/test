//
//  UserCell.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose
//

import Kingfisher
import UIKit

class UserCell: UITableViewCell {
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setup(user: UserDTO) {
        if let avatar = user.avatar, let url = URL(string: avatar) {
            self.avatarImage.kf.setImage(with: url)
        }
        self.nameLabel.text = user.name
        self.timeLabel.text = user.timestamp?.offsetFrom(date: Date())
    }
    
    override func prepareForReuse() {
        self.avatarImage.image = nil
        self.nameLabel.text = ""
        self.timeLabel.text = ""
    }
}
