//
//  SettingTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/11.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var urlBtnOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func urlBtnPressed(_ sender: Any) {
        if let url = URL(string: "https://www.themoviedb.org/?language=zh-TW") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
}
