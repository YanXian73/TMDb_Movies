//
//  MyCollectionViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    var imageName : String?
    var date : Date!
    
}
