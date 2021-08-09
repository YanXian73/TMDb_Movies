//
//  ShowMovieTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/29.
//

import UIKit

class ShowMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var videoLabel: UILabel!
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
//    @IBAction func openURLPressed(_ sender: Any) {
//        openURL()
//    }
//    func openURL() {
//        if let url = URL(string: videoBtnOutlet.title(for: .normal)!){
//            UIApplication.shared.open(url, options: [:])
//        }
//    }
    
    @IBAction func remindBtnPressed(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = "Time coming"
        content.subtitle = "Watch Movie"
        content.body = "Movie! Movie! Movie!"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let date = self.datePicker.date
        let calendar = Calendar.current
        let components = calendar.dateComponents([ .year, .month, .day, .hour, .minute],
            from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        self.datePicker.date = date
    }
}
