//
//  MeTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/21.
//

import UIKit

class MeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
