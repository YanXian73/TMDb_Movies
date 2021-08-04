//
//  MyCollectionViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testimage: UIImageView!
    
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var checkMarkLabel: UILabel!
    var imageName : String?
    
   static let width = floor((UIScreen.main.bounds.width - 3 * 2) / 3)  // 設定每一排3張照片 間距是3，有兩個間距
        override func awakeFromNib() {
            super.awakeFromNib() // cell產生前都會先執行
           imageWidth.constant = Self.width
        }
    @IBAction func addImage(_ sender: Any) {
    }
}

