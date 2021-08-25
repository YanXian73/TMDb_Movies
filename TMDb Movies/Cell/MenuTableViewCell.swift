//
//  MenuTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/26.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
// 設置邊距
//    override var frame: CGRect {
//            get {
//                return super.frame
//            }
//            set {
//                var frame = newValue
//                frame.origin.x += 15
//                frame.size.width -= 2 * 15
//                super.frame = frame
//            }
//        }
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
