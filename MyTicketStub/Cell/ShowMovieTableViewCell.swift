//
//  ShowMovieTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/29.
//

import UIKit

class ShowMovieTableViewCell: UITableViewCell {

   
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var videoBtnOutlet: UIButton!
    @IBOutlet weak var originTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var backGropImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var overViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func openURLPressed(_ sender: Any) {
        openURL()
    }
    func openURL() {
        if let url = URL(string: videoBtnOutlet.title(for: .normal)!){
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
