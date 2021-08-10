//
//  ShowMovieTableViewCell.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/29.
//

import UIKit
import CoreData

class ShowMovieTableViewCell: UITableViewCell {

    let moc = CoreDataHelper.shared.managedObjectContext()
  
    @IBOutlet weak var movieNameLabel: UILabel!
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
    
    var isRemind = false
    
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
    
    @IBAction func remindSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            createNotifiction()
            datePicker.isHidden = true
        }else{
            removeNotifiction()
            datePicker.isHidden = false
        }
        
    }
    
    func createNotifiction() {
        let remind = Remind(context: moc)
        let content = UNMutableNotificationContent()
        content.title = "\(self.titleLabel.text ?? "查無資訊")"
        content.subtitle = "Watch Movie"
        content.body = "Movie! Movie! Movie!"
        content.badge =  1
        content.sound = UNNotificationSound.default
        
        let date = self.datePicker.date
        let calendar = Calendar.current
        let components = calendar.dateComponents([ .year, .month, .day, .hour, .minute],
                                                 from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "\(self.titleLabel.text ?? "")", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        let formatterDate = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .short)
        self.remindLabel.text = "通知日期：\(formatterDate)"
        remind.movieName = self.titleLabel.text
        remind.remind = self.remindLabel.text
        CoreDataHelper.shared.saveContext()
   
    }
    func removeNotifiction(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(self.titleLabel.text ?? "")"])
        self.remindLabel.text = "設定通知："
        
        
    }
}
