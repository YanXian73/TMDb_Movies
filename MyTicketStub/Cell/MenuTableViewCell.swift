//
//  MenuTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/26.
//

import UIKit

class MenuTableViewCell: UITableViewCell {



    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
