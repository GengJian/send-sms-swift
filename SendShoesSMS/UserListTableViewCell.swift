//
//  UserListTableViewCell.swift
//  SendShoesSMS
//
//  Created by GengJian on 2021/12/24.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    func setModel(_ model: UserModel?) {
        if let model = model {
            DispatchQueue.main.async {
                self.idLabel.text = String.init(format: "%d", model.id)
                self.nameLabel.text = model.firstName! + "+" + model.lastName!
                self.numLabel.text = model.firstId! + "****" + model.lastId!
            }
        }
    }
    
}
