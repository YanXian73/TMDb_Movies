//
//  MoviesTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/25.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    
 
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var starBtnOutlet: UIButton!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
