//
//  MyTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/24.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "name", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
        }))
      let text = alert.textFields?[0]
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
